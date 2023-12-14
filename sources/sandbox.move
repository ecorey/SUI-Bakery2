module sandbox::bakery_testing {

    use sui::transfer;
    use std::string::{Self, String};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

   
   // STRUCTS
    struct Flour has key, store {
        id: UID,
        name: String
    }

    struct Salt has key, store {
        id: UID,
        name: String
    }

    struct Yeast has key, store {
        id: UID,
        name: String
    }

    struct Bakery has key, store {
        id: UID,
        flour_created: u64,
        salt_created: u64,
        yeast_created: u64
    }

    // INIT
    fun init(ctx: &mut TxContext) {
        transfer::share_object(
            Bakery {
                id: object::new(ctx),
                flour_created: 0,
                salt_created: 0,
                yeast_created: 0
            }
        )
    }

    // HELPER FUNCTIONS
    // Flour
    public entry fun create_flour(bakery: &mut Bakery, flour_name: vector<u8>, ctx: &mut TxContext) {
        transfer::transfer(
            Flour {
                id: object::new(ctx),
                name: string::utf8(flour_name)
            }, tx_context::sender(ctx)
        );

        bakery.flour_created = bakery.flour_created + 1;
    }

    public entry fun transfer_flour(flour: Flour, recipient: address) {
        transfer::transfer(flour, recipient);
    }

    // Salt
    public entry fun create_salt(bakery: &mut Bakery, salt_name: vector<u8>, ctx: &mut TxContext) {
        transfer::transfer(
            Salt {
                id: object::new(ctx),
                name: string::utf8(salt_name)
            }, tx_context::sender(ctx)
        );

        bakery.salt_created = bakery.salt_created + 1;
    }

    public entry fun transfer_salt(salt: Salt, recipient: address) {
        transfer::transfer(salt, recipient);
    }


    // Yeast
    public entry fun create_yeast(bakery: &mut Bakery, yeast_name: vector<u8>, ctx: &mut TxContext) {
        transfer::transfer(
            Yeast {
                id: object::new(ctx),
                name: string::utf8(yeast_name)
            }, tx_context::sender(ctx)
        );

        bakery.yeast_created = bakery.yeast_created + 1;
    }

    #[test]
    fun test_flour() {

        use sui::test_scenario;
        
        let admin = @0x123;
        let initial_owner = @0x456;
        let final_owner = @0x789;
        
        // tx 1: init module
        let scenario_val = test_scenario::begin(admin);
        let scenario = &mut scenario_val;
        {
            init(test_scenario::ctx(scenario));
        };

        // tx 2: `initial_owner` creates car
        test_scenario::next_tx(scenario, initial_owner);
        {
            let bakery = test_scenario::take_shared<Bakery>(scenario);
            assert!(bakery.flour_created == 0, 0);
            create_flour(&mut bakery, b"Flour Brand", test_scenario::ctx(scenario));
            assert!(bakery.flour_created == 1, 0);
            test_scenario::return_shared<Bakery>(bakery);
        };

        // tx 3: `initial_owner` transfers car to `final_owner`
        test_scenario::next_tx(scenario, initial_owner);
        {
            let flour = test_scenario::take_from_sender<Flour>(scenario);
            transfer_flour(flour, final_owner);
        };

        // tx 4: check to see if `final_owner` has a `Car` by deleting it
        test_scenario::next_tx(scenario, final_owner);
        {
            let flour = test_scenario::take_from_sender<Flour>(scenario);
            let Flour { id, name: _,} = flour;
            object::delete(id);
        };

        test_scenario::end(scenario_val);
    }

    #[test]
    fun test_salt() {

    use sui::test_scenario;
    
    let admin = @0x123;
    let initial_owner = @0x456;
    let final_owner = @0x789;
    
    // tx 1: init module
    let scenario_val = test_scenario::begin(admin);
    let scenario = &mut scenario_val;
    {
        init(test_scenario::ctx(scenario));
    };

    // tx 2: `initial_owner` creates car
    test_scenario::next_tx(scenario, initial_owner);
    {
        let bakery = test_scenario::take_shared<Bakery>(scenario);
        assert!(bakery.salt_created == 0, 0);
        create_salt(&mut bakery, b"Salt Brand", test_scenario::ctx(scenario));
        assert!(bakery.salt_created == 1, 0);
        test_scenario::return_shared<Bakery>(bakery);
    };

    // tx 3: `initial_owner` transfers car to `final_owner`
    test_scenario::next_tx(scenario, initial_owner);
    {
        let salt = test_scenario::take_from_sender<Salt>(scenario);
        transfer_salt(salt, final_owner);
    };

    // tx 4: check to see if `final_owner` has a `Car` by deleting it
    test_scenario::next_tx(scenario, final_owner);
    {
        let salt = test_scenario::take_from_sender<Salt>(scenario);
        let Salt { id, name: _,} = salt;
        object::delete(id);
    };

    test_scenario::end(scenario_val);
}
}