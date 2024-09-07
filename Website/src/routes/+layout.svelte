<script>
	import '../app.css';
	import { setMode, ModeWatcher } from 'mode-watcher';
	import Navbar from './Navigation.svelte'; // Import the new Navbar component

	setMode('dark');
</script>

<div class="fixed inset-0 w-full h-screen bg-gradient-to-b from-primary-background to-ring">
	<div
		class="absolute inset-0"
		style="background-image: radial-gradient(circle, rgba(255,255,255,0.1) 1px, transparent 1px); background-size: 40px 40px;"
	/>
	<div
		class="absolute inset-0 bg-gradient-to-t from-gray-900 via-transparent to-transparent opacity-70"
	/>
</div>

<ModeWatcher />

<Navbar />
<!-- Add the Navbar component here -->

<div class="relative min-h-screen pt-14">
	<!-- Add padding-top to account for the fixed navbar -->
	<slot />
</div>
