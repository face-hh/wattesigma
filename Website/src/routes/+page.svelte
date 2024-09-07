<script>
	import { Label } from '$lib/components/ui/label';
	import { Card, CardContent, CardHeader, CardTitle } from '$lib/components/ui/card';
	import { Button } from '$lib/components/ui/button';
	import {
		Chrome,
		Cog,
		Search,
		Download,
		FileText,
		Gamepad2,
		Tv2,
		Bot,
		Hammer,
		Image,
		Search as SearchIcon
	} from 'lucide-svelte';
	import { Badge } from '$lib/components/ui/badge';
</script>

<div class="flex flex-col items-center justify-center min-h-screen p-4">
	<div class="container mx-auto flex flex-col lg:flex-row items-center justify-between gap-8 mb-16">
		<div class="flex flex-col max-w-xl lg:max-w-2xl">
			<Label class="text-white text-3xl md:text-5xl font-bold mb-2">Bussin</Label>
			<Label
				class="text-4xl md:text-6xl lg:text-8xl font-extrabold bg-clip-text text-transparent bg-[linear-gradient(to_right,theme(colors.indigo.400),theme(colors.indigo.100),theme(colors.sky.400),theme(colors.fuchsia.400),theme(colors.sky.400),theme(colors.indigo.100),theme(colors.indigo.400))] bg-[length:200%_auto] animate-gradient leading-[1.2] pb-6"
			>
				Wattesigma
			</Label>
			<Label class="text-white/90 text-lg"
				>The web browser that <span class="font-bold">truly</span> innovates the web experience.</Label
			>
		</div>
		<div class="mt-8 lg:mt-0 w-full lg:w-[150%] aspect-video">
			<video
				src="/preview.mp4"
				autoplay
				loop
				muted
				playsinline
				class="w-full h-full object-cover rounded-lg shadow-xl"
			/>
		</div>
	</div>

	<div class="w-full max-w-6xl mx-auto grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
		<Card>
			<CardHeader>
				<Chrome class="w-10 h-10 mb-2 text-indigo-400" />
				<CardTitle>Powered by Chromium and Godot</CardTitle>
			</CardHeader>
			<CardContent>
				<p>
					Experience blazing-fast browsing with the power of Chromium Embedded Framework (CEF),
					seamlessly integrated with Godot's robust game engine capabilities.
				</p>
			</CardContent>
		</Card>

		<Card>
			<CardHeader>
				<Cog class="w-10 h-10 mb-2 text-sky-400" />
				<CardTitle>Customizable to Your Liking</CardTitle>
			</CardHeader>
			<CardContent>
				<p>
					Tailor your browsing experience by toggling shaders, choosing your preferred accent color,
					and more. Make Wattesigma truly yours.
				</p>
			</CardContent>
		</Card>

		<Card>
			<CardHeader>
				<Search class="w-10 h-10 mb-2 text-fuchsia-400" />
				<CardTitle>Diverse Search Engine Selection</CardTitle>
			</CardHeader>
			<CardContent>
				<p>Choose from a wide array of search engines, including:</p>
				<div class="flex flex-wrap gap-2 mt-2">
					<Badge variant="outline" class="flex items-center"
						><FileText class="w-4 h-4 mr-1" /> IRS</Badge
					>
					<Badge variant="outline" class="flex items-center"
						><Gamepad2 class="w-4 h-4 mr-1" /> Roblox</Badge
					>
					<Badge variant="outline" class="flex items-center"><Tv2 class="w-4 h-4 mr-1" /> BBC</Badge
					>
					<Badge variant="outline" class="flex items-center"
						><Bot class="w-4 h-4 mr-1" /> Character AI</Badge
					>
					<Badge variant="outline" class="flex items-center"
						><Hammer class="w-4 h-4 mr-1" /> Praktiker.bg</Badge
					>
					<Badge variant="outline" class="flex items-center"
						><Image class="w-4 h-4 mr-1" /> Pinterest</Badge
					>
					<Badge variant="outline" class="flex items-center"
						><SearchIcon class="w-4 h-4 mr-1" /> DuckDuckGo</Badge
					>
				</div>
			</CardContent>
		</Card>
	</div>

	<div class="mt-16 text-center">
		<Button
			variant="outline"
			class="border text-xl p-6"
			on:click={() =>
				(window.location.href = 'https://github.com/face-hh/wattesigma/releases/latest')}
		>
			<Download class="mr-2 h-6 w-6" /> Download
		</Button>
	</div>
</div>

<svelte:head>
	<title>Wattesigma</title>
</svelte:head>