class FarMar::Vendor

    attr_accessor :vendor_id, :name, :employees, :market_id

    # ID - (Fixnum) uniquely identifies the vendor
    # Name - (String) the name of the vendor (not guaranteed unique)
    # No. of Employees - (Fixnum) How many employees the vendor has at the market
    # Market_id - (Fixnum) a reference to which market the vendor attends
    def initialize(vendor_info_hash)
        @vendor_id = vendor_info_hash[:vendor_id]
        @name = vendor_info_hash[:name]
        @employees = vendor_info_hash[:employees]
        @market_id = vendor_info_hash[:market_id]
    end #initialize

    def self.all
        all_vendors = {}
        CSV.read('support/vendors.csv').each do |line|
            new_vendor_info_hash = {
                vendor_id: line[0].to_i,
                name: line[1],
                employees: line[2].to_i,
                market_id: line[3].to_i
            }

            all_vendors[line[0].to_i] = self.new(new_vendor_info_hash)
        end # CSV.open

        return all_vendors
    end # self.all

    def self.find(vendor_id)
        raise ArgumentError, "Expected a Fixnum vendor_id" if vendor_id.class != Fixnum

        return self.all[vendor_id]
    end # self.find

    # self.by_market(market_id): returns all of the vendors with the given market_id
    def self.by_market(market_id)
        raise ArgumentError, "Expected a Fixnum market_id" if market_id.class != Fixnum

        return self.all.values.select { |vendor| vendor.market_id == market_id }
    end

    #market: returns the FarMar::Market instance that is associated with this vendor using the FarMar::Vendor market_id field
    def market
        return FarMar::Market.find(@market_id)
    end #market

    #products: returns a collection of FarMar::Product instances that are associated by the FarMar::Product vendor_id field.
    def products
        return FarMar::Product.all.values.select { |product| product.vendor_id == @vendor_id }
    end #products

    #sales: returns a collection of FarMar::Sale instances that are associated by the vendor_id field.
    def sales
        return FarMar::Sale.all.values.select { |sale| sale.vendor_id == @vendor_id }
    end #sales

    #revenue: returns the the sum of all of the vendor's sales (in cents)
    def revenue
        sale_amounts = sales.map { |sale| sale.amount }
        sale_total = sale_amounts.reduce(:+)
        return sale_total
    end

end # FarMar::Vendor
