#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
}

#[starknet::contract]
pub mod counter_contract {
    use super::ICounter;
    #[storage]
    struct Storage {
        counter: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_value: u32) {
        self.counter.write(initial_value);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState>{
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }
    }
}
