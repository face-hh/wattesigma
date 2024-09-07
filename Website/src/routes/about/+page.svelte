<script>
	import { Button } from '$lib/components/ui/button';
	import { Card, CardContent, CardHeader, CardTitle } from '$lib/components/ui/card';
	import { Badge } from '$lib/components/ui/badge';
	import { Youtube, Code, Coffee, Brain, Rocket, Star } from 'lucide-svelte';

	let link = 'https://www.youtube.com/faceDevStuff';
</script>

<div class="container mx-auto px-4 py-16 max-w-4xl">
	<h1 class="text-4xl font-extrabold mb-8 text-center">
		About Us
		<Badge variant="outline" class="ml-2 align-middle">im literally one guy dawg what "us"</Badge>
	</h1>

	<div class="bg-card text-card-foreground rounded-lg p-6 mb-8">
		<p class="text-xl mb-4">This project was created by FaceDev</p>
		<ul class="list-disc pl-6 space-y-2">
			<li>if you use linux i wish your tire pops today</li>
			<li>if you use vim/neovim/emacs i wish your tire pops today</li>
			<li>if you ever talked bad against windows i wish your tire pops today</li>
		</ul>
	</div>

	<div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center">
					<Code class="w-6 h-6 mr-2 text-primary" />
					Code Cleanness
				</CardTitle>
			</CardHeader>
			<CardContent>
				<p>
					this shit dirtier than <a
						href="https://www.google.com/search?q=asmongold%27s+room"
						class="text-blue-400"
						target="_blank">asmongold's room</a
					>. no joke
				</p>
			</CardContent>
		</Card>
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center">
					<Coffee class="w-6 h-6 mr-2 text-primary" />
					Caffeine Powered
				</CardTitle>
			</CardHeader>
			<CardContent>
				<p>
					ion drink coffee. i only consume <a
						href="https://en.wikipedia.org/wiki/Kvass"
						class="text-blue-400"
						target="_blank">kvass</a
					>
				</p>
			</CardContent>
		</Card>
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center">
					<Brain class="w-6 h-6 mr-2 text-primary" />
					Big Brain Energy
				</CardTitle>
			</CardHeader>
			<CardContent>
				<p>shut the fuck up</p>
			</CardContent>
		</Card>
		<Card>
			<CardHeader>
				<CardTitle class="flex items-center">
					<Rocket class="w-6 h-6 mr-2 text-primary" />
					To Infinity and Beyond!
				</CardTitle>
			</CardHeader>
			<CardContent>
				<p>i hate multiple cursors</p>
			</CardContent>
		</Card>
	</div>

	<div class="bg-muted p-6 rounded-lg mb-8">
		<h2 class="text-2xl font-bold mb-4 flex items-center">
			<Star class="w-6 h-6 mr-2 text-yellow-400" />
			Why FaceDev is the GOAT
		</h2>
		<ul class="list-disc pl-6 space-y-2">
			<li>i dont fw linux</li>
			<li>i dont fw raw css</li>
			<li>i fw svelte</li>
			<li>i dont fw you if you dont use vscode</li>
		</ul>
	</div>

	<div class="text-center">
		<Button variant="default" class="animate-pulse" on:click={() => window.open(link, '_blank')}>
			<Youtube class="w-5 h-5 mr-2" />
			i guess
		</Button>
	</div>
</div>

<svelte:head>
	<title>Wattesigma - About Us</title>
</svelte:head>