#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
}

#[starknet::interface]
trait IKillSwitch<TContractState> {
    fn is_active(self: @TContractState) -> bool;
}

#[starknet::contract]
pub mod counter_contract {
    use super::ICounter;
    use starknet::ContractAddress;
    use super::{IKillSwitchDispatcher, IKillSwitchDispatcherTrait};

    #[storage]
    struct Storage {
        counter: u32,
        kill_switch: ContractAddress,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32, kill_switch_address: ContractAddress) {
        self.counter.write(initial_value);
        self.kill_switch.write(kill_switch_address);
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncreased,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        pub value: u32,
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState>{
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState)  {
            let result = IKillSwitchDispatcher { contract_address: self.kill_switch.read() };

            assert!(!result.is_active(), "Kill Switch is active");

            let new_counter = self.counter.read() + 1;
            self.counter.write(new_counter);
            self.emit(CounterIncreased { value: new_counter });
                
        }
    }
}
