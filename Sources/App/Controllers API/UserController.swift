import Vapor
import HTTP
import FluentMySQL
import Fluent

final class UserController: ResourceRepresentable {
	
	fileprivate let defaultAmount = 20
	
	func index(request: Request) throws -> ResponseRepresentable {
		
		let amount: Int
		
		if let amountParameter = request.data["amount"]?.int {
			
			guard amountParameter > 0 && amountParameter <= 20 else {
				throw Abort.badRequest
			}
			
			amount = amountParameter
			
		} else {
			
			amount = defaultAmount
			
		}
		
		let face = try User.query().filter("approved", .equals, true).sort("quality", .descending)
		face.limit = Limit(count: amount, offset: 0)
		return try face.all().makeJSON(request: request)
	}
	
	func makeResource() -> Resource<User> {
		return Resource(
			index: index
		)
	}
	
}

extension Request {
	func user() throws -> User {
		guard let json = json else { throw Abort.badRequest }
		return try User(node: json)
	}
}
