/// A FetchRequest built from raw SQL.
public struct SQLRequest<RowDecoder> {
    /// There are two statement caches: one "public" for statements generated by
    /// the user, and one "internal" for the statements generated by GRDB. Those
    /// are separated so that GRDB has no opportunity to inadvertently modify
    /// the arguments of user's cached statements.
    enum Cache {
        /// The public cache, for library user
        case `public`
        
        /// The internal cache, for GRDB
        case `internal`
    }
    
    /// The request adapter
    public var adapter: RowAdapter?
    
    private(set) var sqlLiteral: SQL
    let cache: Cache?
    
    /// Creates a request from an SQL string, optional arguments, and
    /// optional row adapter.
    ///
    ///     let request = SQLRequest<String>(sql: """
    ///         SELECT name FROM player
    ///         """)
    ///     let request = SQLRequest<Player>(sql: """
    ///         SELECT * FROM player WHERE id = ?
    ///         """, arguments: [1])
    ///
    /// - parameters:
    ///     - sql: An SQL query.
    ///     - arguments: Statement arguments.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    /// - returns: A SQLRequest
    public init(
        sql: String,
        arguments: StatementArguments = StatementArguments(),
        adapter: RowAdapter? = nil,
        cached: Bool = false)
    {
        self.init(
            literal: SQL(sql: sql, arguments: arguments),
            adapter: adapter,
            fromCache: cached ? .public : nil)
    }
    
    /// Creates a request from an `SQL` literal, and optional row adapter.
    ///
    /// Literals allow you to safely embed raw values in your SQL, without any
    /// risk of syntax errors or SQL injection:
    ///
    ///     let name = "O'brien"
    ///     let request = SQLRequest<Player>(literal: """
    ///         SELECT * FROM player WHERE name = \(name)
    ///         """)
    ///
    /// - parameters:
    ///     - sqlLiteral: An `SQL` literal.
    ///     - adapter: Optional RowAdapter.
    ///     - cached: Defaults to false. If true, the request reuses a cached
    ///       prepared statement.
    /// - returns: A SQLRequest
    public init(literal sqlLiteral: SQL, adapter: RowAdapter? = nil, cached: Bool = false) {
        self.init(literal: sqlLiteral, adapter: adapter, fromCache: cached ? .public : nil)
    }
    
    init(literal sqlLiteral: SQL, adapter: RowAdapter? = nil, fromCache cache: Cache?) {
        self.sqlLiteral = sqlLiteral
        self.adapter = adapter
        self.cache = cache
    }
}

extension SQLRequest: FetchRequest {
    public var sqlSubquery: SQLSubquery {
        .literal(sqlLiteral)
    }
    
    public func fetchCount(_ db: Database) throws -> Int {
        try SQLRequest<Int>("SELECT COUNT(*) FROM (\(self))").fetchOne(db)!
    }
    
    public func makePreparedRequest(
        _ db: Database,
        forSingleResult singleResult: Bool = false)
    throws -> PreparedRequest
    {
        let context = SQLGenerationContext(db)
        let sql = try sqlLiteral.sql(context)
        let statement: SelectStatement
        switch cache {
        case .none:
            statement = try db.makeSelectStatement(sql: sql)
        case .public?:
            statement = try db.cachedSelectStatement(sql: sql)
        case .internal?:
            statement = try db.internalCachedSelectStatement(sql: sql)
        }
        try statement.setArguments(context.arguments)
        return PreparedRequest(statement: statement, adapter: adapter)
    }
}

extension SQLRequest: ExpressibleByStringInterpolation {
    /// :nodoc
    public init(unicodeScalarLiteral: String) {
        self.init(sql: unicodeScalarLiteral)
    }
    
    /// :nodoc:
    public init(extendedGraphemeClusterLiteral: String) {
        self.init(sql: extendedGraphemeClusterLiteral)
    }
    
    /// :nodoc:
    public init(stringLiteral: String) {
        self.init(sql: stringLiteral)
    }
    
    /// :nodoc:
    public init(stringInterpolation sqlInterpolation: SQLInterpolation) {
        self.init(literal: SQL(stringInterpolation: sqlInterpolation))
    }
}
