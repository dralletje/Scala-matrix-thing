### Input

it needs an input of every possible planned slot possible. So every possible single relation ship between independent variables, and a function that compares those to eachother and returns a measurement of "working together"-ness.

With the cars, that would be PERSON - CAR - TIMESLOT, and a function that would simple make sure a PERSON and CAR are both only once available per TIMESLOT.

{
  "drivers": [
    { id: 1, name: 'Jake', license: ['BE'] },
    { id: 2, name: 'Mike', license: ['C'] },
  ],
  "cars": [
    { id: 3, plate: 'XXX', license: ['C'] },
    { id: 4, plate: 'LLL', license: ['BE'] },
  ]
}

would become

[
  [2, 3],
  [1, 4],
]

Maybe?

{
  "hours_per_driver": 40,
  "shift_range": { // 4, 8, 12
    min: 4,
    max: 12,
    step: 4,
  },
  "drivers": [
    { id: 1, name: 'Jake', license: ['BE'] },
    { id: 2, name: 'Mike', license: ['C'] },
  ],
  "cars": [
    { id: 3, plate: 'XXX', license: ['C'] },
    { id: 4, plate: 'LLL', license: ['BE'] },
  ],
}

[
  [1,]
]
