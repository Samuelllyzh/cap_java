using { sap.capire.bookstore as db } from '../db/schema';

// Define Books Service
service BooksService{
    @readonly entity Books as projection   on db.Books { *, category as genre } excluding { category, createdBy, createdAt, modifiedBy, modifiedAt };
    @readonly entity Authors as projection on db.Authors;
}

// Define Orders Service
// 这样，您就可以授予管理员对所有订单的访问权限，而普通用户只能看到他们创建的订单。
// 当您OrderItems作为单独的实体公开时，您还必须在那里添加安全配置。
// parent我们在关联中使用指向 的路径表达式Orders，将项目限制为属于相应用户创建的订单的项目。
service OrdersService {
    // @(restrict: [
    //     { grant: '*', to: 'Administrators' },
    //     { grant: '*', where: 'createdBy = $user' }
    // ])
    entity Orders as projection on db.Orders;


    entity OrderItems as projection on db.OrderItems;
}

// Reuse Admin Service
using { AdminService } from '@sap/capire-products';
extend service AdminService with {
    entity Authors as projection on db.Authors;
}

annotate AdminService @(requires: 'Administrators');