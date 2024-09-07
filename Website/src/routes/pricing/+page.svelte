<script>
	import { Button } from '$lib/components/ui/button';
	import {
		Card,
		CardContent,
		CardDescription,
		CardFooter,
		CardHeader,
		CardTitle
	} from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
	import { Check, X, Zap, Crown, Building, Mail } from 'lucide-svelte';

	let enterpriseEmail = 'gary74920@gmail.com';
</script>

<div class="container mx-auto px-4 py-16 max-w-6xl">
	<h1 class="text-4xl font-extrabold mb-8 text-center">Pricing</h1>

	<p class="text-xl text-center mb-12">Choose the option that fits you the best!</p>

	<div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
		<!-- Free Tier -->
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center justify-between">
					Free Tier
					<Zap class="w-6 h-6 text-yellow-400" />
				</CardTitle>
				<CardDescription>For the ones that use AWS</CardDescription>
			</CardHeader>
			<CardContent>
				<p class="text-3xl font-bold mb-4">$0.00</p>
				<ul class="space-y-2">
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						Basic features (they're all basic)
					</li>
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						No hidden fees (i dont have the time to add them)
					</li>
					<li class="flex items-center">
						<X class="w-5 h-5 mr-2 text-red-500" />
						No premium support (you're on your own cuh)
					</li>
				</ul>
			</CardContent>
			<CardFooter>
				<Button variant="outline" class="w-full">Start now</Button>
			</CardFooter>
		</Card>

		<!-- Pro Tier -->
		<Card class="border-primary shadow-lg transform scale-105">
			<CardHeader>
				<div class="flex items-center justify-between">
					<CardTitle class="flex items-center">
						Pro Tier
						<Crown class="w-6 h-6 ml-2 text-yellow-400" />
					</CardTitle>
					<Badge variant="secondary">PREFERRED</Badge>
				</div>
				<CardDescription>For true sigmas</CardDescription>
			</CardHeader>
			<CardContent>
				<p class="text-3xl font-bold mb-4">$0.00</p>
				<ul class="space-y-2">
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						All Free features (still basic)
					</li>
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						Premium support (we might answer) <span class="text-[0.25rem]">(we wont)</span>
					</li>
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						erm wattesigma
					</li>
				</ul>
			</CardContent>
			<CardFooter>
				<Button variant="default" class="w-full">Go Pro</Button>
			</CardFooter>
		</Card>

		<!-- Enterprise Tier -->
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center justify-between">
					Enterprise
					<Building class="w-6 h-6 text-primary" />
				</CardTitle>
				<CardDescription>For companies</CardDescription>
			</CardHeader>
			<CardContent>
				<p class="text-3xl font-bold mb-4">$0.00</p>
				<ul class="space-y-2">
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						All Pro features
					</li>
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						24/7 support (that wont fucking happen)
					</li>
					<li class="flex items-center">
						<Check class="w-5 h-5 mr-2 text-green-500" />
						Custom solutions (this wont happen either)
					</li>
				</ul>
			</CardContent>
			<CardFooter>
				<Button
					variant="outline"
					class="w-full"
					on:click={() => (window.location.href = `mailto:${enterpriseEmail}`)}
				>
					<Mail class="w-5 h-5 mr-2" />
					Contact Us (we wont reply)
				</Button>
			</CardFooter>
		</Card>
	</div>

	<div class="text-center">
		<p class="text-lg mb-4">Still not convinced? i dont fucking care</p>
		<Button variant="link" class="text-primary" on:click={() => window.location.href = "https://www.youtube.com/watch?v=TXliGqaW8uk"}>
			Learn more about our pricing
		</Button>
	</div>
</div>
