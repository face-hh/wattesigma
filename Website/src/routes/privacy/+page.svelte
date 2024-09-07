<script>
	import { Button } from '$lib/components/ui/button';
	import {
		Accordion,
		AccordionItem,
		AccordionTrigger,
		AccordionContent
	} from '$lib/components/ui/accordion';
	import { Badge } from '$lib/components/ui/badge';
	import { Trash2, Eye, ShieldOff, Cookie, Fingerprint } from 'lucide-svelte';
</script>

<div class="container mx-auto px-4 py-16 max-w-3xl">
	<h1 class="text-4xl font-extrabold mb-8 text-center">
		Our Privacy Policy
		<Badge variant="outline" class="ml-2 align-middle">(sort of)</Badge>
	</h1>

	<div class="bg-card text-card-foreground rounded-lg p-6 mb-8">
		<p class="text-xl mb-4">In summary:</p>
		<ul class="list-disc pl-6 space-y-2">
			<li>We collect as much data as possible.</li>
			<li>Your secrets are safe with us. If everything is public, nothing can be leaked!</li>
			<li>Our respect for your privacy is somewhat existent.</li>
		</ul>
	</div>

	<Accordion class="mb-8">
		<AccordionItem value="item-1">
			<AccordionTrigger>What data do we collect?</AccordionTrigger>
			<AccordionContent>
				<div class="flex items-center space-x-2">
					<Trash2 class="w-6 h-6 text-primary" />
					<span>Nothing dawg, it's a fucking browser</span>
				</div>
			</AccordionContent>
		</AccordionItem>
		<AccordionItem value="item-2">
			<AccordionTrigger>How do we use your data?</AccordionTrigger>
			<AccordionContent>
				<div class="flex items-center space-x-2">
					<Eye class="w-6 h-6 text-primary" />
					<span>we don't 👍</span>
				</div>
			</AccordionContent>
		</AccordionItem>
		<AccordionItem value="item-3">
			<AccordionTrigger>How do we protect your data?</AccordionTrigger>
			<AccordionContent>
				<div class="flex items-center space-x-2">
					<ShieldOff class="w-6 h-6 text-primary" />
					<span>we do not</span>
				</div>
			</AccordionContent>
		</AccordionItem>
	</Accordion>

	<div class="bg-muted p-4 rounded-lg mb-8">
		<h2 class="text-2xl font-bold mb-4 flex items-center">
			<Cookie class="w-6 h-6 mr-2" />
			Cookie Policy
		</h2>
		<p>
			there are no fucking cookies you donut. I mean there are, in your appdata because its a
			fucking browser. this website though doesnt store shit
		</p>
	</div>

	<div class="bg-muted p-4 rounded-lg mb-8">
		<h2 class="text-2xl font-bold mb-4 flex items-center">
			<Fingerprint class="w-6 h-6 mr-2" />
			Fingerprinting Policy
		</h2>
		<p>WHAT THE FUCK DO YOU MEAN FINGERPRINTING POLICY</p>
	</div>

	<div class="text-center">
		<Button variant="outline" class="animate-bounce">No devious trickery, pinkie promise</Button>
	</div>
</div>

<svelte:head>
	<title>Wattesigma - Privacy</title>
</svelte:head>