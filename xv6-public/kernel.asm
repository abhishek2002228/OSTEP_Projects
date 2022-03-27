
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 00 d9 10 80       	mov    $0x8010d900,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 34 d9 10 80       	mov    $0x8010d934,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 40 74 10 80       	push   $0x80107440
80100055:	68 00 d9 10 80       	push   $0x8010d900
8010005a:	e8 a1 44 00 00       	call   80104500 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 1f 11 80       	mov    $0x80111ffc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 20 11 80 fc 	movl   $0x80111ffc,0x8011204c
8010006e:	1f 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 20 11 80 fc 	movl   $0x80111ffc,0x80112050
80100078:	1f 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 1f 11 80 	movl   $0x80111ffc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 74 10 80       	push   $0x80107447
80100097:	50                   	push   %eax
80100098:	e8 23 43 00 00       	call   801043c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 20 11 80       	mov    0x80112050,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 20 11 80    	mov    %ebx,0x80112050
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 1d 11 80    	cmp    $0x80111da0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 00 d9 10 80       	push   $0x8010d900
801000e8:	e8 93 45 00 00       	call   80104680 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 20 11 80    	mov    0x80112050,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 1f 11 80    	cmp    $0x80111ffc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 1f 11 80    	cmp    $0x80111ffc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 20 11 80    	mov    0x8011204c,%ebx
80100126:	81 fb fc 1f 11 80    	cmp    $0x80111ffc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 1f 11 80    	cmp    $0x80111ffc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 d9 10 80       	push   $0x8010d900
80100162:	e8 d9 45 00 00       	call   80104740 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 42 00 00       	call   80104400 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 4e 74 10 80       	push   $0x8010744e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 d9 42 00 00       	call   801044a0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 5f 74 10 80       	push   $0x8010745f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 98 42 00 00       	call   801044a0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 48 42 00 00       	call   80104460 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 d9 10 80 	movl   $0x8010d900,(%esp)
8010021f:	e8 5c 44 00 00       	call   80104680 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 50 20 11 80       	mov    0x80112050,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 1f 11 80 	movl   $0x80111ffc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 20 11 80       	mov    0x80112050,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 20 11 80    	mov    %ebx,0x80112050
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 d9 10 80 	movl   $0x8010d900,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 cb 44 00 00       	jmp    80104740 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 66 74 10 80       	push   $0x80107466
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 ca 43 00 00       	call   80104680 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 e0 22 11 80       	mov    0x801122e0,%eax
801002cb:	3b 05 e4 22 11 80    	cmp    0x801122e4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 e0 22 11 80       	push   $0x801122e0
801002e5:	e8 36 3d 00 00       	call   80104020 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 22 11 80       	mov    0x801122e0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 22 11 80    	cmp    0x801122e4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 91 36 00 00       	call   80103990 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 2d 44 00 00       	call   80104740 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 e0 22 11 80    	mov    %edx,0x801122e0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 22 11 80 	movsbl -0x7feedda0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 d6 43 00 00       	call   80104740 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 e0 22 11 80       	mov    %eax,0x801122e0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 6d 74 10 80       	push   $0x8010746d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 e3 7d 10 80 	movl   $0x80107de3,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 3f 41 00 00       	call   80104520 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 81 74 10 80       	push   $0x80107481
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 61 5b 00 00       	call   80105f90 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 76 5a 00 00       	call   80105f90 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 5a 00 00       	call   80105f90 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 5a 00 00       	call   80105f90 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ca 42 00 00       	call   80104830 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 42 00 00       	call   80104790 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 85 74 10 80       	push   $0x80107485
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 b0 74 10 80 	movzbl -0x7fef8b50(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 1c 40 00 00       	call   80104680 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 a4 40 00 00       	call   80104740 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 98 74 10 80       	mov    $0x80107498,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 be 3e 00 00       	call   80104680 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 13 3f 00 00       	call   80104740 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 9f 74 10 80       	push   $0x8010749f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 04 3e 00 00       	call   80104680 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 e8 22 11 80       	mov    0x801122e8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 22 11 80    	sub    0x801122e0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 22 11 80    	mov    %ecx,0x801122e8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 22 11 80    	mov    %bl,-0x7feedda0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 e0 22 11 80       	mov    0x801122e0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 22 11 80    	cmp    %eax,0x801122e8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 22 11 80       	mov    0x801122e8,%eax
80100925:	39 05 e4 22 11 80    	cmp    %eax,0x801122e4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 22 11 80 0a 	cmpb   $0xa,-0x7feedda0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 e8 22 11 80       	mov    %eax,0x801122e8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 e8 22 11 80       	mov    0x801122e8,%eax
8010096f:	3b 05 e4 22 11 80    	cmp    0x801122e4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 22 11 80       	mov    0x801122e8,%eax
80100985:	3b 05 e4 22 11 80    	cmp    0x801122e4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 22 11 80       	mov    %eax,0x801122e8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 6c 3d 00 00       	call   80104740 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 60 22 11 80 0a 	movb   $0xa,-0x7feedda0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 dc 38 00 00       	jmp    801042e0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 22 11 80       	mov    0x801122e8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 22 11 80       	mov    %eax,0x801122e4
          wakeup(&input.r);
80100a1b:	68 e0 22 11 80       	push   $0x801122e0
80100a20:	e8 bb 37 00 00       	call   801041e0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 a8 74 10 80       	push   $0x801074a8
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 b7 3a 00 00       	call   80104500 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 2c 11 80 40 	movl   $0x80100640,0x80112cac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 2c 11 80 90 	movl   $0x80100290,0x80112ca8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 fb 2e 00 00       	call   80103990 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 ef 65 00 00       	call   80107100 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 a8 63 00 00       	call   80106f20 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 a2 62 00 00       	call   80106e50 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 90 64 00 00       	call   80107080 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 62 00 00       	call   80106f20 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 48 65 00 00       	call   801071a0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 e8 3c 00 00       	call   80104990 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 d5 3c 00 00       	call   80104990 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 34 66 00 00       	call   80107300 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 63 00 00       	call   80107080 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 c8 65 00 00       	call   80107300 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 da 3b 00 00       	call   80104950 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 1e 5f 00 00       	call   80106cc0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 62 00 00       	call   80107080 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 c1 74 10 80       	push   $0x801074c1
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 cd 74 10 80       	push   $0x801074cd
80100def:	68 00 23 11 80       	push   $0x80112300
80100df4:	e8 07 37 00 00       	call   80104500 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb 34 23 11 80       	mov    $0x80112334,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 00 23 11 80       	push   $0x80112300
80100e15:	e8 66 38 00 00       	call   80104680 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 94 2c 11 80    	cmp    $0x80112c94,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 00 23 11 80       	push   $0x80112300
80100e41:	e8 fa 38 00 00       	call   80104740 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 00 23 11 80       	push   $0x80112300
80100e5a:	e8 e1 38 00 00       	call   80104740 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 00 23 11 80       	push   $0x80112300
80100e83:	e8 f8 37 00 00       	call   80104680 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 00 23 11 80       	push   $0x80112300
80100ea0:	e8 9b 38 00 00       	call   80104740 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 d4 74 10 80       	push   $0x801074d4
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 00 23 11 80       	push   $0x80112300
80100ed5:	e8 a6 37 00 00       	call   80104680 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 00 23 11 80       	push   $0x80112300
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 2b 38 00 00       	call   80104740 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 00 23 11 80 	movl   $0x80112300,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 fd 37 00 00       	jmp    80104740 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 dc 74 10 80       	push   $0x801074dc
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 e6 74 10 80       	push   $0x801074e6
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 ef 74 10 80       	push   $0x801074ef
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 f5 74 10 80       	push   $0x801074f5
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 18 2d 11 80    	add    0x80112d18,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 ff 74 10 80       	push   $0x801074ff
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 18 2d 11 80    	add    0x80112d18,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 00 2d 11 80    	cmp    %eax,0x80112d00
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 12 75 10 80       	push   $0x80107512
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 76 34 00 00       	call   80104790 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 20 2d 11 80       	push   $0x80112d20
8010135a:	e8 21 33 00 00       	call   80104680 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 74 49 11 80    	cmp    $0x80114974,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 74 49 11 80    	cmp    $0x80114974,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 20 2d 11 80       	push   $0x80112d20
801013c7:	e8 74 33 00 00       	call   80104740 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 20 2d 11 80       	push   $0x80112d20
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 46 33 00 00       	call   80104740 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 74 49 11 80    	cmp    $0x80114974,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 28 75 10 80       	push   $0x80107528
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 38 75 10 80       	push   $0x80107538
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 06 33 00 00       	call   80104830 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 60 2d 11 80       	mov    $0x80112d60,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 4b 75 10 80       	push   $0x8010754b
80101555:	68 20 2d 11 80       	push   $0x80112d20
8010155a:	e8 a1 2f 00 00       	call   80104500 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 52 75 10 80       	push   $0x80107552
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 44 2e 00 00       	call   801043c0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 80 49 11 80    	cmp    $0x80114980,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 00 2d 11 80       	push   $0x80112d00
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 18 2d 11 80    	pushl  0x80112d18
8010159d:	ff 35 14 2d 11 80    	pushl  0x80112d14
801015a3:	ff 35 10 2d 11 80    	pushl  0x80112d10
801015a9:	ff 35 0c 2d 11 80    	pushl  0x80112d0c
801015af:	ff 35 08 2d 11 80    	pushl  0x80112d08
801015b5:	ff 35 04 2d 11 80    	pushl  0x80112d04
801015bb:	ff 35 00 2d 11 80    	pushl  0x80112d00
801015c1:	68 b8 75 10 80       	push   $0x801075b8
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d 08 2d 11 80 01 	cmpl   $0x1,0x80112d08
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d 08 2d 11 80    	cmp    0x80112d08,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 14 2d 11 80    	add    0x80112d14,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 2d 31 00 00       	call   80104790 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 58 75 10 80       	push   $0x80107558
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 14 2d 11 80    	add    0x80112d14,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 26 31 00 00       	call   80104830 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 20 2d 11 80       	push   $0x80112d20
80101743:	e8 38 2f 00 00       	call   80104680 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80101753:	e8 e8 2f 00 00       	call   80104740 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 75 2c 00 00       	call   80104400 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 14 2d 11 80    	add    0x80112d14,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 33 30 00 00       	call   80104830 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 70 75 10 80       	push   $0x80107570
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 6a 75 10 80       	push   $0x8010756a
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 44 2c 00 00       	call   801044a0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 e8 2b 00 00       	jmp    80104460 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 7f 75 10 80       	push   $0x8010757f
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 57 2b 00 00       	call   80104400 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 9d 2b 00 00       	call   80104460 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801018ca:	e8 b1 2d 00 00       	call   80104680 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 57 2e 00 00       	jmp    80104740 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 20 2d 11 80       	push   $0x80112d20
801018f8:	e8 83 2d 00 00       	call   80104680 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80101907:	e8 34 2e 00 00       	call   80104740 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 24 2d 00 00       	call   80104830 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 a0 2c 11 80 	mov    -0x7feed360(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 28 2c 00 00       	call   80104830 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 a4 2c 11 80 	mov    -0x7feed35c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 f9 2b 00 00       	call   801048a0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 96 2b 00 00       	call   801048a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 99 75 10 80       	push   $0x80107599
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 87 75 10 80       	push   $0x80107587
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 01 1c 00 00       	call   80103990 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 20 2d 11 80       	push   $0x80112d20
80101d9c:	e8 df 28 00 00       	call   80104680 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80101dac:	e8 8f 29 00 00       	call   80104740 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 14 2a 00 00       	call   80104830 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 88 29 00 00       	call   80104830 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 16 29 00 00       	call   801048f0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 a8 75 10 80       	push   $0x801075a8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 ca 7b 10 80       	push   $0x80107bca
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 14 76 10 80       	push   $0x80107614
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 0b 76 10 80       	push   $0x8010760b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 26 76 10 80       	push   $0x80107626
8010215f:	68 80 a5 10 80       	push   $0x8010a580
80102164:	e8 97 23 00 00       	call   80104500 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 40 50 11 80       	mov    0x80115040,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 a5 10 80       	push   $0x8010a580
801021f2:	e8 89 24 00 00       	call   80104680 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 8e 1f 00 00       	call   801041e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 a5 10 80       	push   $0x8010a580
8010226b:	e8 d0 24 00 00       	call   80104740 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 09 22 00 00       	call   801044a0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 a5 10 80       	push   $0x8010a580
801022cc:	e8 af 23 00 00       	call   80104680 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 a5 10 80       	push   $0x8010a580
80102318:	53                   	push   %ebx
80102319:	e8 02 1d 00 00       	call   80104020 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 05 24 00 00       	jmp    80104740 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 55 76 10 80       	push   $0x80107655
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 40 76 10 80       	push   $0x80107640
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 2a 76 10 80       	push   $0x8010762a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 74 49 11 80 00 	movl   $0xfec00000,0x80114974
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 74 49 11 80    	mov    0x80114974,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 a0 4a 11 80 	movzbl 0x80114aa0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 74 76 10 80       	push   $0x80107674
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 74 49 11 80    	mov    0x80114974,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 74 49 11 80       	mov    0x80114974,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 e5 22 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 b4 49 11 80    	mov    0x801149b4,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 b8 49 11 80       	mov    0x801149b8,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 b4 49 11 80       	mov    0x801149b4,%eax
  kmem.freelist = r;
801024c4:	89 1d b8 49 11 80    	mov    %ebx,0x801149b8
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 80 49 11 80       	push   $0x80114980
801024e0:	e8 9b 21 00 00       	call   80104680 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 80 49 11 80 	movl   $0x80114980,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 40 22 00 00       	jmp    80104740 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 a6 76 10 80       	push   $0x801076a6
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 ac 76 10 80       	push   $0x801076ac
80102574:	68 80 49 11 80       	push   $0x80114980
80102579:	e8 82 1f 00 00       	call   80104500 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 b4 49 11 80 00 	movl   $0x0,0x801149b4
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 b4 49 11 80 01 	movl   $0x1,0x801149b4
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 b4 49 11 80       	mov    0x801149b4,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 b8 49 11 80       	mov    0x801149b8,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 b8 49 11 80    	mov    %edx,0x801149b8
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 80 49 11 80       	push   $0x80114980
80102663:	e8 18 20 00 00       	call   80104680 <acquire>
  r = kmem.freelist;
80102668:	a1 b8 49 11 80       	mov    0x801149b8,%eax
  if(r)
8010266d:	8b 15 b4 49 11 80    	mov    0x801149b4,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d b8 49 11 80    	mov    %ecx,0x801149b8
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 80 49 11 80       	push   $0x80114980
80102691:	e8 aa 20 00 00       	call   80104740 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a e0 77 10 80 	movzbl -0x7fef8820(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 e0 76 10 80 	movzbl -0x7fef8920(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a e0 77 10 80 	movzbl -0x7fef8820(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 bc 49 11 80       	mov    0x801149bc,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 bc 49 11 80       	mov    0x801149bc,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 bc 49 11 80       	mov    0x801149bc,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 bc 49 11 80       	mov    0x801149bc,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 1c 1d 00 00       	call   801047e0 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d 08 4a 11 80    	mov    0x80114a08,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 f4 49 11 80       	mov    0x801149f4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 04 4a 11 80    	pushl  0x80114a04
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd 0c 4a 11 80 	pushl  -0x7feeb5f4(,%edi,4)
80102bd4:	ff 35 04 4a 11 80    	pushl  0x80114a04
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 37 1c 00 00       	call   80104830 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d 08 4a 11 80    	cmp    %edi,0x80114a08
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 f4 49 11 80    	pushl  0x801149f4
80102c3d:	ff 35 04 4a 11 80    	pushl  0x80114a04
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 08 4a 11 80       	mov    0x80114a08,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 0c 4a 11 80 	mov    -0x7feeb5f4(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 e0 78 10 80       	push   $0x801078e0
80102ca3:	68 c0 49 11 80       	push   $0x801149c0
80102ca8:	e8 53 18 00 00       	call   80104500 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d 04 4a 11 80    	mov    %ebx,0x80114a04
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 f4 49 11 80       	mov    %eax,0x801149f4
  log.size = sb.nlog;
80102ccb:	89 15 f8 49 11 80    	mov    %edx,0x801149f8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d 08 4a 11 80    	mov    %ecx,0x80114a08
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 0c 4a 11 80 	mov    %ebx,-0x7feeb5f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 08 4a 11 80 00 	movl   $0x0,0x80114a08
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 c0 49 11 80       	push   $0x801149c0
80102d3f:	e8 3c 19 00 00       	call   80104680 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 c0 49 11 80       	push   $0x801149c0
80102d58:	68 c0 49 11 80       	push   $0x801149c0
80102d5d:	e8 be 12 00 00       	call   80104020 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 00 4a 11 80       	mov    0x80114a00,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 fc 49 11 80       	mov    0x801149fc,%eax
80102d73:	8b 15 08 4a 11 80    	mov    0x80114a08,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 fc 49 11 80       	mov    %eax,0x801149fc
      release(&log.lock);
80102d8f:	68 c0 49 11 80       	push   $0x801149c0
80102d94:	e8 a7 19 00 00       	call   80104740 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 c0 49 11 80       	push   $0x801149c0
80102db2:	e8 c9 18 00 00       	call   80104680 <acquire>
  log.outstanding -= 1;
80102db7:	a1 fc 49 11 80       	mov    0x801149fc,%eax
  if(log.committing)
80102dbc:	8b 35 00 4a 11 80    	mov    0x80114a00,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d fc 49 11 80    	mov    %ebx,0x801149fc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 00 4a 11 80 01 	movl   $0x1,0x80114a00
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 c0 49 11 80       	push   $0x801149c0
80102df0:	e8 4b 19 00 00       	call   80104740 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d 08 4a 11 80    	mov    0x80114a08,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 c0 49 11 80       	push   $0x801149c0
80102e0a:	e8 71 18 00 00       	call   80104680 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
    log.committing = 0;
80102e16:	c7 05 00 4a 11 80 00 	movl   $0x0,0x80114a00
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 bb 13 00 00       	call   801041e0 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
80102e2c:	e8 0f 19 00 00       	call   80104740 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 f4 49 11 80       	mov    0x801149f4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 04 4a 11 80    	pushl  0x80114a04
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d 0c 4a 11 80 	pushl  -0x7feeb5f4(,%ebx,4)
80102e64:	ff 35 04 4a 11 80    	pushl  0x80114a04
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 a7 19 00 00       	call   80104830 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d 08 4a 11 80    	cmp    0x80114a08,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 08 4a 11 80 00 	movl   $0x0,0x80114a08
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 c0 49 11 80       	push   $0x801149c0
80102ed8:	e8 03 13 00 00       	call   801041e0 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 c0 49 11 80 	movl   $0x801149c0,(%esp)
80102ee4:	e8 57 18 00 00       	call   80104740 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 e4 78 10 80       	push   $0x801078e4
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 08 4a 11 80    	mov    0x80114a08,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 f8 49 11 80       	mov    0x801149f8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 fc 49 11 80       	mov    0x801149fc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 c0 49 11 80       	push   $0x801149c0
80102f52:	e8 29 17 00 00       	call   80104680 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 08 4a 11 80    	mov    0x80114a08,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 0c 4a 11 80 	cmp    %ecx,-0x7feeb5f4(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 0c 4a 11 80 	mov    %ecx,-0x7feeb5f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 c0 49 11 80 	movl   $0x801149c0,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 a6 17 00 00       	jmp    80104740 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 0c 4a 11 80 	mov    %ecx,-0x7feeb5f4(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 08 4a 11 80    	mov    %edx,0x80114a08
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 0c 4a 11 80       	mov    %eax,0x80114a0c
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 f3 78 10 80       	push   $0x801078f3
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 09 79 10 80       	push   $0x80107909
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 84 09 00 00       	call   80103970 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 7d 09 00 00       	call   80103970 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 24 79 10 80       	push   $0x80107924
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 c9 2b 00 00       	call   80105bd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 f4 08 00 00       	call   80103900 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 71 0c 00 00       	call   80103c90 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 71 3c 00 00       	call   80106ca0 <switchkvm>
  seginit();
8010302f:	e8 dc 3b 00 00       	call   80106c10 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 a8 58 11 80       	push   $0x801158a8
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 16 41 00 00       	call   80107180 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 97 3b 00 00       	call   80106c10 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 43 2e 00 00       	call   80105ed0 <uartinit>
  pinit();         // process table
8010308d:	e8 4e 08 00 00       	call   801038e0 <pinit>
  tvinit();        // trap vectors
80103092:	e8 b9 2a 00 00       	call   80105b50 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 90 a4 10 80       	push   $0x8010a490
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 73 17 00 00       	call   80104830 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 40 50 11 80 b0 	imul   $0xb0,0x80115040,%eax
801030c7:	00 00 00 
801030ca:	05 c0 4a 11 80       	add    $0x80114ac0,%eax
801030cf:	3d c0 4a 11 80       	cmp    $0x80114ac0,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb c0 4a 11 80       	mov    $0x80114ac0,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 40 50 11 80 b0 	imul   $0xb0,0x80115040,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 c0 4a 11 80       	add    $0x80114ac0,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 02 08 00 00       	call   80103900 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010311b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 59 08 00 00       	call   801039c0 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 38 79 10 80       	push   $0x80107938
801031a3:	56                   	push   %esi
801031a4:	e8 37 16 00 00       	call   801047e0 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 3d 79 10 80       	push   $0x8010793d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 78 15 00 00       	call   801047e0 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 bc 49 11 80       	mov    %eax,0x801149bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d a0 4a 11 80    	mov    %cl,0x80114aa0
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 40 50 11 80    	mov    0x80115040,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 40 50 11 80    	mov    %ecx,0x80115040
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f c0 4a 11 80    	mov    %bl,-0x7feeb540(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 42 79 10 80       	push   $0x80107942
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 5c 79 10 80       	push   $0x8010795c
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 7b 79 10 80       	push   $0x8010797b
8010346c:	50                   	push   %eax
8010346d:	e8 8e 10 00 00       	call   80104500 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 68 11 00 00       	call   80104680 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 a8 0c 00 00       	call   801041e0 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 e3 11 00 00       	jmp    80104740 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 67 0c 00 00       	call   801041e0 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 b7 11 00 00       	call   80104740 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 ca 10 00 00       	call   80104680 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 93 03 00 00       	call   80103990 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 d3 0b 00 00       	call   801041e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 0a 0a 00 00       	call   80104020 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 ff 10 00 00       	call   80104740 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 51 0b 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 a9 10 00 00       	call   80104740 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 c1 0f 00 00       	call   80104680 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 b3 02 00 00       	call   80103990 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 2e 09 00 00       	call   80104020 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 85 0a 00 00       	call   801041e0 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 dd 0f 00 00       	call   80104740 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 c2 0f 00 00       	call   80104740 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb f4 a5 10 80       	mov    $0x8010a5f4,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 c0 a5 10 80       	push   $0x8010a5c0
801037a1:	e8 da 0e 00 00       	call   80104680 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801037b6:	81 fb f4 c8 10 80    	cmp    $0x8010c8f4,%ebx
801037bc:	0f 84 96 00 00 00    	je     80103858 <allocproc+0xc8>
    if(p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->readcount = 0;
  p->tickets = 1;
  p->ticks = 0;
  release(&ptable.lock);
801037ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->readcount = 0;
801037d8:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801037df:	89 43 10             	mov    %eax,0x10(%ebx)
801037e2:	8d 50 01             	lea    0x1(%eax),%edx
  p->tickets = 1;
801037e5:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
801037ec:	00 00 00 
  p->ticks = 0;
801037ef:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801037f6:	00 00 00 
  release(&ptable.lock);
801037f9:	68 c0 a5 10 80       	push   $0x8010a5c0
  p->pid = nextpid++;
801037fe:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103804:	e8 37 0f 00 00       	call   80104740 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103809:	e8 22 ee ff ff       	call   80102630 <kalloc>
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	89 43 08             	mov    %eax,0x8(%ebx)
80103814:	85 c0                	test   %eax,%eax
80103816:	74 59                	je     80103871 <allocproc+0xe1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103818:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381e:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103821:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103826:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103829:	c7 40 14 3d 5b 10 80 	movl   $0x80105b3d,0x14(%eax)
  p->context = (struct context*)sp;
80103830:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103833:	6a 14                	push   $0x14
80103835:	6a 00                	push   $0x0
80103837:	50                   	push   %eax
80103838:	e8 53 0f 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
8010383d:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103840:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103843:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
}
8010384a:	89 d8                	mov    %ebx,%eax
8010384c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384f:	c9                   	leave  
80103850:	c3                   	ret    
80103851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010385b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010385d:	68 c0 a5 10 80       	push   $0x8010a5c0
80103862:	e8 d9 0e 00 00       	call   80104740 <release>
}
80103867:	89 d8                	mov    %ebx,%eax
  return 0;
80103869:	83 c4 10             	add    $0x10,%esp
}
8010386c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386f:	c9                   	leave  
80103870:	c3                   	ret    
    p->state = UNUSED;
80103871:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103878:	31 db                	xor    %ebx,%ebx
}
8010387a:	89 d8                	mov    %ebx,%eax
8010387c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010387f:	c9                   	leave  
80103880:	c3                   	ret    
80103881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388f:	90                   	nop

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	f3 0f 1e fb          	endbr32 
80103894:	55                   	push   %ebp
80103895:	89 e5                	mov    %esp,%ebp
80103897:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010389a:	68 c0 a5 10 80       	push   $0x8010a5c0
8010389f:	e8 9c 0e 00 00       	call   80104740 <release>

  if (first) {
801038a4:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038a9:	83 c4 10             	add    $0x10,%esp
801038ac:	85 c0                	test   %eax,%eax
801038ae:	75 08                	jne    801038b8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038b8:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801038bf:	00 00 00 
    iinit(ROOTDEV);
801038c2:	83 ec 0c             	sub    $0xc,%esp
801038c5:	6a 01                	push   $0x1
801038c7:	e8 74 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038d3:	e8 b8 f3 ff ff       	call   80102c90 <initlog>
}
801038d8:	83 c4 10             	add    $0x10,%esp
801038db:	c9                   	leave  
801038dc:	c3                   	ret    
801038dd:	8d 76 00             	lea    0x0(%esi),%esi

801038e0 <pinit>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038ea:	68 80 79 10 80       	push   $0x80107980
801038ef:	68 c0 a5 10 80       	push   $0x8010a5c0
801038f4:	e8 07 0c 00 00       	call   80104500 <initlock>
}
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	c9                   	leave  
801038fd:	c3                   	ret    
801038fe:	66 90                	xchg   %ax,%ax

80103900 <mycpu>:
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	55                   	push   %ebp
80103905:	89 e5                	mov    %esp,%ebp
80103907:	56                   	push   %esi
80103908:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103909:	9c                   	pushf  
8010390a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010390b:	f6 c4 02             	test   $0x2,%ah
8010390e:	75 4a                	jne    8010395a <mycpu+0x5a>
  apicid = lapicid();
80103910:	e8 8b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103915:	8b 35 40 50 11 80    	mov    0x80115040,%esi
  apicid = lapicid();
8010391b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010391d:	85 f6                	test   %esi,%esi
8010391f:	7e 2c                	jle    8010394d <mycpu+0x4d>
80103921:	31 d2                	xor    %edx,%edx
80103923:	eb 0a                	jmp    8010392f <mycpu+0x2f>
80103925:	8d 76 00             	lea    0x0(%esi),%esi
80103928:	83 c2 01             	add    $0x1,%edx
8010392b:	39 f2                	cmp    %esi,%edx
8010392d:	74 1e                	je     8010394d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010392f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103935:	0f b6 81 c0 4a 11 80 	movzbl -0x7feeb540(%ecx),%eax
8010393c:	39 d8                	cmp    %ebx,%eax
8010393e:	75 e8                	jne    80103928 <mycpu+0x28>
}
80103940:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103943:	8d 81 c0 4a 11 80    	lea    -0x7feeb540(%ecx),%eax
}
80103949:	5b                   	pop    %ebx
8010394a:	5e                   	pop    %esi
8010394b:	5d                   	pop    %ebp
8010394c:	c3                   	ret    
  panic("unknown apicid\n");
8010394d:	83 ec 0c             	sub    $0xc,%esp
80103950:	68 87 79 10 80       	push   $0x80107987
80103955:	e8 36 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010395a:	83 ec 0c             	sub    $0xc,%esp
8010395d:	68 64 7a 10 80       	push   $0x80107a64
80103962:	e8 29 ca ff ff       	call   80100390 <panic>
80103967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010396e:	66 90                	xchg   %ax,%ax

80103970 <cpuid>:
cpuid() {
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010397a:	e8 81 ff ff ff       	call   80103900 <mycpu>
}
8010397f:	c9                   	leave  
  return mycpu()-cpus;
80103980:	2d c0 4a 11 80       	sub    $0x80114ac0,%eax
80103985:	c1 f8 04             	sar    $0x4,%eax
80103988:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010398e:	c3                   	ret    
8010398f:	90                   	nop

80103990 <myproc>:
myproc(void) {
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	53                   	push   %ebx
80103998:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010399b:	e8 e0 0b 00 00       	call   80104580 <pushcli>
  c = mycpu();
801039a0:	e8 5b ff ff ff       	call   80103900 <mycpu>
  p = c->proc;
801039a5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039ab:	e8 20 0c 00 00       	call   801045d0 <popcli>
}
801039b0:	83 c4 04             	add    $0x4,%esp
801039b3:	89 d8                	mov    %ebx,%eax
801039b5:	5b                   	pop    %ebx
801039b6:	5d                   	pop    %ebp
801039b7:	c3                   	ret    
801039b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039bf:	90                   	nop

801039c0 <userinit>:
{
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	53                   	push   %ebx
801039c8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039cb:	e8 c0 fd ff ff       	call   80103790 <allocproc>
801039d0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039d2:	a3 f4 c8 10 80       	mov    %eax,0x8010c8f4
  if((p->pgdir = setupkvm()) == 0)
801039d7:	e8 24 37 00 00       	call   80107100 <setupkvm>
801039dc:	89 43 04             	mov    %eax,0x4(%ebx)
801039df:	85 c0                	test   %eax,%eax
801039e1:	0f 84 d1 00 00 00    	je     80103ab8 <userinit+0xf8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039e7:	83 ec 04             	sub    $0x4,%esp
801039ea:	68 2c 00 00 00       	push   $0x2c
801039ef:	68 64 a4 10 80       	push   $0x8010a464
801039f4:	50                   	push   %eax
801039f5:	e8 d6 33 00 00       	call   80106dd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039fa:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039fd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a03:	6a 4c                	push   $0x4c
80103a05:	6a 00                	push   $0x0
80103a07:	ff 73 18             	pushl  0x18(%ebx)
80103a0a:	e8 81 0d 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a12:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a17:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a1a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a1f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a23:	8b 43 18             	mov    0x18(%ebx),%eax
80103a26:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a2a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a31:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a35:	8b 43 18             	mov    0x18(%ebx),%eax
80103a38:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a3c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a40:	8b 43 18             	mov    0x18(%ebx),%eax
80103a43:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a4a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a4d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a54:	8b 43 18             	mov    0x18(%ebx),%eax
80103a57:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a5e:	8d 43 6c             	lea    0x6c(%ebx),%eax
  p->tickets = 1;
80103a61:	c7 83 80 00 00 00 01 	movl   $0x1,0x80(%ebx)
80103a68:	00 00 00 
  p->ticks = 0;
80103a6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103a72:	00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a75:	6a 10                	push   $0x10
80103a77:	68 b0 79 10 80       	push   $0x801079b0
80103a7c:	50                   	push   %eax
80103a7d:	e8 ce 0e 00 00       	call   80104950 <safestrcpy>
  p->cwd = namei("/");
80103a82:	c7 04 24 b9 79 10 80 	movl   $0x801079b9,(%esp)
80103a89:	e8 a2 e5 ff ff       	call   80102030 <namei>
80103a8e:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a91:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80103a98:	e8 e3 0b 00 00       	call   80104680 <acquire>
  p->state = RUNNABLE;
80103a9d:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aa4:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80103aab:	e8 90 0c 00 00       	call   80104740 <release>
}
80103ab0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	c9                   	leave  
80103ab7:	c3                   	ret    
    panic("userinit: out of memory?");
80103ab8:	83 ec 0c             	sub    $0xc,%esp
80103abb:	68 97 79 10 80       	push   $0x80107997
80103ac0:	e8 cb c8 ff ff       	call   80100390 <panic>
80103ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ad0 <growproc>:
{
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	56                   	push   %esi
80103ad8:	53                   	push   %ebx
80103ad9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103adc:	e8 9f 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103ae1:	e8 1a fe ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ae6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aec:	e8 df 0a 00 00       	call   801045d0 <popcli>
  sz = curproc->sz;
80103af1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103af3:	85 f6                	test   %esi,%esi
80103af5:	7f 19                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af7:	75 37                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103afc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afe:	53                   	push   %ebx
80103aff:	e8 bc 31 00 00       	call   80106cc0 <switchuvm>
  return 0;
80103b04:	83 c4 10             	add    $0x10,%esp
80103b07:	31 c0                	xor    %eax,%eax
}
80103b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b0c:	5b                   	pop    %ebx
80103b0d:	5e                   	pop    %esi
80103b0e:	5d                   	pop    %ebp
80103b0f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 01 34 00 00       	call   80106f20 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 d3                	jne    80103af9 <growproc+0x29>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb dc                	jmp    80103b09 <growproc+0x39>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	pushl  0x4(%ebx)
80103b3a:	e8 11 35 00 00       	call   80107050 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 b3                	jne    80103af9 <growproc+0x29>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b4f:	90                   	nop

80103b50 <fork>:
{
80103b50:	f3 0f 1e fb          	endbr32 
80103b54:	55                   	push   %ebp
80103b55:	89 e5                	mov    %esp,%ebp
80103b57:	57                   	push   %edi
80103b58:	56                   	push   %esi
80103b59:	53                   	push   %ebx
80103b5a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b5d:	e8 1e 0a 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103b62:	e8 99 fd ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103b67:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b6d:	e8 5e 0a 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103b72:	e8 19 fc ff ff       	call   80103790 <allocproc>
80103b77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b7a:	85 c0                	test   %eax,%eax
80103b7c:	0f 84 d3 00 00 00    	je     80103c55 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b82:	83 ec 08             	sub    $0x8,%esp
80103b85:	ff 33                	pushl  (%ebx)
80103b87:	89 c7                	mov    %eax,%edi
80103b89:	ff 73 04             	pushl  0x4(%ebx)
80103b8c:	e8 3f 36 00 00       	call   801071d0 <copyuvm>
80103b91:	83 c4 10             	add    $0x10,%esp
80103b94:	89 47 04             	mov    %eax,0x4(%edi)
80103b97:	85 c0                	test   %eax,%eax
80103b99:	0f 84 bd 00 00 00    	je     80103c5c <fork+0x10c>
  np->sz = curproc->sz;
80103b9f:	8b 03                	mov    (%ebx),%eax
80103ba1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  *np->tf = *curproc->tf;
80103ba4:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103ba9:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103bab:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103bae:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103bb1:	8b 73 18             	mov    0x18(%ebx),%esi
80103bb4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103bb6:	31 f6                	xor    %esi,%esi
  np->tickets = curproc->tickets;
80103bb8:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  np->ticks = 0;
80103bbe:	c7 82 84 00 00 00 00 	movl   $0x0,0x84(%edx)
80103bc5:	00 00 00 
  np->tickets = curproc->tickets;
80103bc8:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  np->tf->eax = 0;
80103bce:	8b 42 18             	mov    0x18(%edx),%eax
80103bd1:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103bd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bdf:	90                   	nop
    if(curproc->ofile[i])
80103be0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 13                	je     80103bfb <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103be8:	83 ec 0c             	sub    $0xc,%esp
80103beb:	50                   	push   %eax
80103bec:	e8 7f d2 ff ff       	call   80100e70 <filedup>
80103bf1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bf4:	83 c4 10             	add    $0x10,%esp
80103bf7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bfb:	83 c6 01             	add    $0x1,%esi
80103bfe:	83 fe 10             	cmp    $0x10,%esi
80103c01:	75 dd                	jne    80103be0 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103c03:	83 ec 0c             	sub    $0xc,%esp
80103c06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c0c:	e8 1f db ff ff       	call   80101730 <idup>
80103c11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c1d:	6a 10                	push   $0x10
80103c1f:	53                   	push   %ebx
80103c20:	50                   	push   %eax
80103c21:	e8 2a 0d 00 00       	call   80104950 <safestrcpy>
  pid = np->pid;
80103c26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c29:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80103c30:	e8 4b 0a 00 00       	call   80104680 <acquire>
  np->state = RUNNABLE;
80103c35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c3c:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80103c43:	e8 f8 0a 00 00       	call   80104740 <release>
  return pid;
80103c48:	83 c4 10             	add    $0x10,%esp
}
80103c4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c4e:	89 d8                	mov    %ebx,%eax
80103c50:	5b                   	pop    %ebx
80103c51:	5e                   	pop    %esi
80103c52:	5f                   	pop    %edi
80103c53:	5d                   	pop    %ebp
80103c54:	c3                   	ret    
    return -1;
80103c55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c5a:	eb ef                	jmp    80103c4b <fork+0xfb>
    kfree(np->kstack);
80103c5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c5f:	83 ec 0c             	sub    $0xc,%esp
80103c62:	ff 73 08             	pushl  0x8(%ebx)
80103c65:	e8 06 e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c71:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c74:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c80:	eb c9                	jmp    80103c4b <fork+0xfb>
80103c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c90 <scheduler>:
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	57                   	push   %edi
80103c98:	bf 00 c9 10 80       	mov    $0x8010c900,%edi
80103c9d:	56                   	push   %esi
80103c9e:	53                   	push   %ebx
80103c9f:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103ca2:	e8 59 fc ff ff       	call   80103900 <mycpu>
  c->proc = 0;
80103ca7:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103cae:	00 00 00 
  struct cpu *c = mycpu();
80103cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
80103cb4:	83 c0 04             	add    $0x4,%eax
80103cb7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  asm volatile("sti");
80103cc0:	fb                   	sti    
    acquire(&ptable.lock);
80103cc1:	83 ec 0c             	sub    $0xc,%esp
    unsigned int totaltickets = 0;
80103cc4:	31 f6                	xor    %esi,%esi
    acquire(&ptable.lock);
80103cc6:	68 c0 a5 10 80       	push   $0x8010a5c0
80103ccb:	e8 b0 09 00 00       	call   80104680 <acquire>
    for(int i = 0; i < NPROC; i++){
80103cd0:	b8 00 a6 10 80       	mov    $0x8010a600,%eax
80103cd5:	83 c4 10             	add    $0x10,%esp
80103cd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop
      if(ptable.proc[i].state == RUNNABLE){
80103ce0:	83 38 03             	cmpl   $0x3,(%eax)
80103ce3:	75 03                	jne    80103ce8 <scheduler+0x58>
        totaltickets = totaltickets + ptable.proc[i].tickets;
80103ce5:	03 70 74             	add    0x74(%eax),%esi
    for(int i = 0; i < NPROC; i++){
80103ce8:	05 8c 00 00 00       	add    $0x8c,%eax
80103ced:	39 c7                	cmp    %eax,%edi
80103cef:	75 ef                	jne    80103ce0 <scheduler+0x50>
    unsigned int winner = next_random() % (totaltickets + 1);
80103cf1:	e8 ea 36 00 00       	call   801073e0 <next_random>
80103cf6:	83 c6 01             	add    $0x1,%esi
80103cf9:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cfb:	bb f4 a5 10 80       	mov    $0x8010a5f4,%ebx
    unsigned int winner = next_random() % (totaltickets + 1);
80103d00:	f7 f6                	div    %esi
    unsigned int counter = 0;
80103d02:	31 f6                	xor    %esi,%esi
      if(p->state != RUNNABLE)
80103d04:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d08:	0f 85 aa 00 00 00    	jne    80103db8 <scheduler+0x128>
      counter = counter + p->tickets;
80103d0e:	03 b3 80 00 00 00    	add    0x80(%ebx),%esi
      if(counter < winner){
80103d14:	39 f2                	cmp    %esi,%edx
80103d16:	0f 87 9c 00 00 00    	ja     80103db8 <scheduler+0x128>
      c->proc = p;  //next process to run is chosen here.
80103d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      switchuvm(p);
80103d1f:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;  //next process to run is chosen here.
80103d22:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
      switchuvm(p);
80103d28:	53                   	push   %ebx
80103d29:	e8 92 2f 00 00       	call   80106cc0 <switchuvm>
      cprintf("about to run: %s [pid %d][tickets %d][ticks %d]\n", p->name, p->pid, p->tickets, p->ticks);
80103d2e:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103d31:	58                   	pop    %eax
80103d32:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
      const int temp = ticks;//this tick used by p.
80103d38:	8b 35 a0 58 11 80    	mov    0x801158a0,%esi
      cprintf("about to run: %s [pid %d][tickets %d][ticks %d]\n", p->name, p->pid, p->tickets, p->ticks);
80103d3e:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
80103d44:	ff 73 10             	pushl  0x10(%ebx)
80103d47:	52                   	push   %edx
80103d48:	68 8c 7a 10 80       	push   $0x80107a8c
      p->state = RUNNING;
80103d4d:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      p->inuse = 1; //process in use after swtch
80103d54:	c7 83 88 00 00 00 01 	movl   $0x1,0x88(%ebx)
80103d5b:	00 00 00 
      cprintf("about to run: %s [pid %d][tickets %d][ticks %d]\n", p->name, p->pid, p->tickets, p->ticks);
80103d5e:	e8 4d c9 ff ff       	call   801006b0 <cprintf>
      swtch(&(c->scheduler), p->context);
80103d63:	83 c4 18             	add    $0x18,%esp
80103d66:	ff 73 1c             	pushl  0x1c(%ebx)
80103d69:	ff 75 e0             	pushl  -0x20(%ebp)
80103d6c:	e8 42 0c 00 00       	call   801049b3 <swtch>
      p->ticks += ticks - temp;
80103d71:	8b 15 a0 58 11 80    	mov    0x801158a0,%edx
      p->inuse = 0;
80103d77:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103d7e:	00 00 00 
      p->ticks += ticks - temp;
80103d81:	29 f2                	sub    %esi,%edx
80103d83:	01 93 84 00 00 00    	add    %edx,0x84(%ebx)
      switchkvm();
80103d89:	e8 12 2f 00 00       	call   80106ca0 <switchkvm>
      c->proc = 0;
80103d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      break; //this is important to avoid round robin 
80103d91:	83 c4 10             	add    $0x10,%esp
      c->proc = 0;
80103d94:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d9b:	00 00 00 
    release(&ptable.lock);
80103d9e:	83 ec 0c             	sub    $0xc,%esp
80103da1:	68 c0 a5 10 80       	push   $0x8010a5c0
80103da6:	e8 95 09 00 00       	call   80104740 <release>
  for(;;){
80103dab:	83 c4 10             	add    $0x10,%esp
80103dae:	e9 0d ff ff ff       	jmp    80103cc0 <scheduler+0x30>
80103db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103db7:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db8:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103dbe:	81 fb f4 c8 10 80    	cmp    $0x8010c8f4,%ebx
80103dc4:	0f 85 3a ff ff ff    	jne    80103d04 <scheduler+0x74>
80103dca:	eb d2                	jmp    80103d9e <scheduler+0x10e>
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dd0 <sched>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	56                   	push   %esi
80103dd8:	53                   	push   %ebx
  pushcli();
80103dd9:	e8 a2 07 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103dde:	e8 1d fb ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103de3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103de9:	e8 e2 07 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	68 c0 a5 10 80       	push   $0x8010a5c0
80103df6:	e8 35 08 00 00       	call   80104630 <holding>
80103dfb:	83 c4 10             	add    $0x10,%esp
80103dfe:	85 c0                	test   %eax,%eax
80103e00:	74 4f                	je     80103e51 <sched+0x81>
  if(mycpu()->ncli != 1)
80103e02:	e8 f9 fa ff ff       	call   80103900 <mycpu>
80103e07:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e0e:	75 68                	jne    80103e78 <sched+0xa8>
  if(p->state == RUNNING)
80103e10:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e14:	74 55                	je     80103e6b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e16:	9c                   	pushf  
80103e17:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e18:	f6 c4 02             	test   $0x2,%ah
80103e1b:	75 41                	jne    80103e5e <sched+0x8e>
  intena = mycpu()->intena;
80103e1d:	e8 de fa ff ff       	call   80103900 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e22:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e25:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e2b:	e8 d0 fa ff ff       	call   80103900 <mycpu>
80103e30:	83 ec 08             	sub    $0x8,%esp
80103e33:	ff 70 04             	pushl  0x4(%eax)
80103e36:	53                   	push   %ebx
80103e37:	e8 77 0b 00 00       	call   801049b3 <swtch>
  mycpu()->intena = intena;
80103e3c:	e8 bf fa ff ff       	call   80103900 <mycpu>
}
80103e41:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e44:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e4a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e4d:	5b                   	pop    %ebx
80103e4e:	5e                   	pop    %esi
80103e4f:	5d                   	pop    %ebp
80103e50:	c3                   	ret    
    panic("sched ptable.lock");
80103e51:	83 ec 0c             	sub    $0xc,%esp
80103e54:	68 bb 79 10 80       	push   $0x801079bb
80103e59:	e8 32 c5 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103e5e:	83 ec 0c             	sub    $0xc,%esp
80103e61:	68 e7 79 10 80       	push   $0x801079e7
80103e66:	e8 25 c5 ff ff       	call   80100390 <panic>
    panic("sched running");
80103e6b:	83 ec 0c             	sub    $0xc,%esp
80103e6e:	68 d9 79 10 80       	push   $0x801079d9
80103e73:	e8 18 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103e78:	83 ec 0c             	sub    $0xc,%esp
80103e7b:	68 cd 79 10 80       	push   $0x801079cd
80103e80:	e8 0b c5 ff ff       	call   80100390 <panic>
80103e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e90 <exit>:
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	57                   	push   %edi
80103e98:	56                   	push   %esi
80103e99:	53                   	push   %ebx
80103e9a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103e9d:	e8 de 06 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103ea2:	e8 59 fa ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103ea7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ead:	e8 1e 07 00 00       	call   801045d0 <popcli>
  if(curproc == initproc)
80103eb2:	8d 5e 28             	lea    0x28(%esi),%ebx
80103eb5:	8d 7e 68             	lea    0x68(%esi),%edi
80103eb8:	39 35 f4 c8 10 80    	cmp    %esi,0x8010c8f4
80103ebe:	0f 84 fd 00 00 00    	je     80103fc1 <exit+0x131>
80103ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103ec8:	8b 03                	mov    (%ebx),%eax
80103eca:	85 c0                	test   %eax,%eax
80103ecc:	74 12                	je     80103ee0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103ece:	83 ec 0c             	sub    $0xc,%esp
80103ed1:	50                   	push   %eax
80103ed2:	e8 e9 cf ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103ed7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103edd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ee0:	83 c3 04             	add    $0x4,%ebx
80103ee3:	39 df                	cmp    %ebx,%edi
80103ee5:	75 e1                	jne    80103ec8 <exit+0x38>
  begin_op();
80103ee7:	e8 44 ee ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
80103eec:	83 ec 0c             	sub    $0xc,%esp
80103eef:	ff 76 68             	pushl  0x68(%esi)
80103ef2:	e8 99 d9 ff ff       	call   80101890 <iput>
  end_op();
80103ef7:	e8 a4 ee ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80103efc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103f03:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80103f0a:	e8 71 07 00 00       	call   80104680 <acquire>
  wakeup1(curproc->parent);
80103f0f:	8b 56 14             	mov    0x14(%esi),%edx
80103f12:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f15:	b8 f4 a5 10 80       	mov    $0x8010a5f4,%eax
80103f1a:	eb 10                	jmp    80103f2c <exit+0x9c>
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f20:	05 8c 00 00 00       	add    $0x8c,%eax
80103f25:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80103f2a:	74 1e                	je     80103f4a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103f2c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f30:	75 ee                	jne    80103f20 <exit+0x90>
80103f32:	3b 50 20             	cmp    0x20(%eax),%edx
80103f35:	75 e9                	jne    80103f20 <exit+0x90>
      p->state = RUNNABLE;
80103f37:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f3e:	05 8c 00 00 00       	add    $0x8c,%eax
80103f43:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80103f48:	75 e2                	jne    80103f2c <exit+0x9c>
      p->parent = initproc;
80103f4a:	8b 0d f4 c8 10 80    	mov    0x8010c8f4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f50:	ba f4 a5 10 80       	mov    $0x8010a5f4,%edx
80103f55:	eb 17                	jmp    80103f6e <exit+0xde>
80103f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5e:	66 90                	xchg   %ax,%ax
80103f60:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103f66:	81 fa f4 c8 10 80    	cmp    $0x8010c8f4,%edx
80103f6c:	74 3a                	je     80103fa8 <exit+0x118>
    if(p->parent == curproc){
80103f6e:	39 72 14             	cmp    %esi,0x14(%edx)
80103f71:	75 ed                	jne    80103f60 <exit+0xd0>
      if(p->state == ZOMBIE)
80103f73:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f77:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f7a:	75 e4                	jne    80103f60 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f7c:	b8 f4 a5 10 80       	mov    $0x8010a5f4,%eax
80103f81:	eb 11                	jmp    80103f94 <exit+0x104>
80103f83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f87:	90                   	nop
80103f88:	05 8c 00 00 00       	add    $0x8c,%eax
80103f8d:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80103f92:	74 cc                	je     80103f60 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103f94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f98:	75 ee                	jne    80103f88 <exit+0xf8>
80103f9a:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f9d:	75 e9                	jne    80103f88 <exit+0xf8>
      p->state = RUNNABLE;
80103f9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fa6:	eb e0                	jmp    80103f88 <exit+0xf8>
  curproc->state = ZOMBIE;
80103fa8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103faf:	e8 1c fe ff ff       	call   80103dd0 <sched>
  panic("zombie exit");
80103fb4:	83 ec 0c             	sub    $0xc,%esp
80103fb7:	68 08 7a 10 80       	push   $0x80107a08
80103fbc:	e8 cf c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 fb 79 10 80       	push   $0x801079fb
80103fc9:	e8 c2 c3 ff ff       	call   80100390 <panic>
80103fce:	66 90                	xchg   %ax,%ax

80103fd0 <yield>:
{
80103fd0:	f3 0f 1e fb          	endbr32 
80103fd4:	55                   	push   %ebp
80103fd5:	89 e5                	mov    %esp,%ebp
80103fd7:	53                   	push   %ebx
80103fd8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103fdb:	68 c0 a5 10 80       	push   $0x8010a5c0
80103fe0:	e8 9b 06 00 00       	call   80104680 <acquire>
  pushcli();
80103fe5:	e8 96 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80103fea:	e8 11 f9 ff ff       	call   80103900 <mycpu>
  p = c->proc;
80103fef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff5:	e8 d6 05 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
80103ffa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104001:	e8 ca fd ff ff       	call   80103dd0 <sched>
  release(&ptable.lock);
80104006:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
8010400d:	e8 2e 07 00 00       	call   80104740 <release>
}
80104012:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104015:	83 c4 10             	add    $0x10,%esp
80104018:	c9                   	leave  
80104019:	c3                   	ret    
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104020 <sleep>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	57                   	push   %edi
80104028:	56                   	push   %esi
80104029:	53                   	push   %ebx
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104030:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104033:	e8 48 05 00 00       	call   80104580 <pushcli>
  c = mycpu();
80104038:	e8 c3 f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
8010403d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104043:	e8 88 05 00 00       	call   801045d0 <popcli>
  if(p == 0)
80104048:	85 db                	test   %ebx,%ebx
8010404a:	0f 84 83 00 00 00    	je     801040d3 <sleep+0xb3>
  if(lk == 0)
80104050:	85 f6                	test   %esi,%esi
80104052:	74 72                	je     801040c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104054:	81 fe c0 a5 10 80    	cmp    $0x8010a5c0,%esi
8010405a:	74 4c                	je     801040a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010405c:	83 ec 0c             	sub    $0xc,%esp
8010405f:	68 c0 a5 10 80       	push   $0x8010a5c0
80104064:	e8 17 06 00 00       	call   80104680 <acquire>
    release(lk);
80104069:	89 34 24             	mov    %esi,(%esp)
8010406c:	e8 cf 06 00 00       	call   80104740 <release>
  p->chan = chan;
80104071:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104074:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010407b:	e8 50 fd ff ff       	call   80103dd0 <sched>
  p->chan = 0;
80104080:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104087:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
8010408e:	e8 ad 06 00 00       	call   80104740 <release>
    acquire(lk);
80104093:	89 75 08             	mov    %esi,0x8(%ebp)
80104096:	83 c4 10             	add    $0x10,%esp
}
80104099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010409c:	5b                   	pop    %ebx
8010409d:	5e                   	pop    %esi
8010409e:	5f                   	pop    %edi
8010409f:	5d                   	pop    %ebp
    acquire(lk);
801040a0:	e9 db 05 00 00       	jmp    80104680 <acquire>
801040a5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801040a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801040ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801040b2:	e8 19 fd ff ff       	call   80103dd0 <sched>
  p->chan = 0;
801040b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040c1:	5b                   	pop    %ebx
801040c2:	5e                   	pop    %esi
801040c3:	5f                   	pop    %edi
801040c4:	5d                   	pop    %ebp
801040c5:	c3                   	ret    
    panic("sleep without lk");
801040c6:	83 ec 0c             	sub    $0xc,%esp
801040c9:	68 1a 7a 10 80       	push   $0x80107a1a
801040ce:	e8 bd c2 ff ff       	call   80100390 <panic>
    panic("sleep");
801040d3:	83 ec 0c             	sub    $0xc,%esp
801040d6:	68 14 7a 10 80       	push   $0x80107a14
801040db:	e8 b0 c2 ff ff       	call   80100390 <panic>

801040e0 <wait>:
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	56                   	push   %esi
801040e8:	53                   	push   %ebx
  pushcli();
801040e9:	e8 92 04 00 00       	call   80104580 <pushcli>
  c = mycpu();
801040ee:	e8 0d f8 ff ff       	call   80103900 <mycpu>
  p = c->proc;
801040f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801040f9:	e8 d2 04 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
801040fe:	83 ec 0c             	sub    $0xc,%esp
80104101:	68 c0 a5 10 80       	push   $0x8010a5c0
80104106:	e8 75 05 00 00       	call   80104680 <acquire>
8010410b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010410e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104110:	bb f4 a5 10 80       	mov    $0x8010a5f4,%ebx
80104115:	eb 17                	jmp    8010412e <wait+0x4e>
80104117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010411e:	66 90                	xchg   %ax,%ax
80104120:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104126:	81 fb f4 c8 10 80    	cmp    $0x8010c8f4,%ebx
8010412c:	74 1e                	je     8010414c <wait+0x6c>
      if(p->parent != curproc)
8010412e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104131:	75 ed                	jne    80104120 <wait+0x40>
      if(p->state == ZOMBIE){
80104133:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104137:	74 37                	je     80104170 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104139:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
8010413f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104144:	81 fb f4 c8 10 80    	cmp    $0x8010c8f4,%ebx
8010414a:	75 e2                	jne    8010412e <wait+0x4e>
    if(!havekids || curproc->killed){
8010414c:	85 c0                	test   %eax,%eax
8010414e:	74 76                	je     801041c6 <wait+0xe6>
80104150:	8b 46 24             	mov    0x24(%esi),%eax
80104153:	85 c0                	test   %eax,%eax
80104155:	75 6f                	jne    801041c6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104157:	83 ec 08             	sub    $0x8,%esp
8010415a:	68 c0 a5 10 80       	push   $0x8010a5c0
8010415f:	56                   	push   %esi
80104160:	e8 bb fe ff ff       	call   80104020 <sleep>
    havekids = 0;
80104165:	83 c4 10             	add    $0x10,%esp
80104168:	eb a4                	jmp    8010410e <wait+0x2e>
8010416a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104170:	83 ec 0c             	sub    $0xc,%esp
80104173:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104176:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104179:	e8 f2 e2 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
8010417e:	5a                   	pop    %edx
8010417f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104182:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104189:	e8 f2 2e 00 00       	call   80107080 <freevm>
        release(&ptable.lock);
8010418e:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
        p->pid = 0;
80104195:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010419c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801041a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801041a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801041ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801041b5:	e8 86 05 00 00       	call   80104740 <release>
        return pid;
801041ba:	83 c4 10             	add    $0x10,%esp
}
801041bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c0:	89 f0                	mov    %esi,%eax
801041c2:	5b                   	pop    %ebx
801041c3:	5e                   	pop    %esi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret    
      release(&ptable.lock);
801041c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801041c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801041ce:	68 c0 a5 10 80       	push   $0x8010a5c0
801041d3:	e8 68 05 00 00       	call   80104740 <release>
      return -1;
801041d8:	83 c4 10             	add    $0x10,%esp
801041db:	eb e0                	jmp    801041bd <wait+0xdd>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi

801041e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041e0:	f3 0f 1e fb          	endbr32 
801041e4:	55                   	push   %ebp
801041e5:	89 e5                	mov    %esp,%ebp
801041e7:	53                   	push   %ebx
801041e8:	83 ec 10             	sub    $0x10,%esp
801041eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ee:	68 c0 a5 10 80       	push   $0x8010a5c0
801041f3:	e8 88 04 00 00       	call   80104680 <acquire>
801041f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fb:	b8 f4 a5 10 80       	mov    $0x8010a5f4,%eax
80104200:	eb 12                	jmp    80104214 <wakeup+0x34>
80104202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104208:	05 8c 00 00 00       	add    $0x8c,%eax
8010420d:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80104212:	74 1e                	je     80104232 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104214:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104218:	75 ee                	jne    80104208 <wakeup+0x28>
8010421a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010421d:	75 e9                	jne    80104208 <wakeup+0x28>
      p->state = RUNNABLE;
8010421f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104226:	05 8c 00 00 00       	add    $0x8c,%eax
8010422b:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80104230:	75 e2                	jne    80104214 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104232:	c7 45 08 c0 a5 10 80 	movl   $0x8010a5c0,0x8(%ebp)
}
80104239:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010423c:	c9                   	leave  
  release(&ptable.lock);
8010423d:	e9 fe 04 00 00       	jmp    80104740 <release>
80104242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104250 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	53                   	push   %ebx
80104258:	83 ec 10             	sub    $0x10,%esp
8010425b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010425e:	68 c0 a5 10 80       	push   $0x8010a5c0
80104263:	e8 18 04 00 00       	call   80104680 <acquire>
80104268:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426b:	b8 f4 a5 10 80       	mov    $0x8010a5f4,%eax
80104270:	eb 12                	jmp    80104284 <kill+0x34>
80104272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104278:	05 8c 00 00 00       	add    $0x8c,%eax
8010427d:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80104282:	74 34                	je     801042b8 <kill+0x68>
    if(p->pid == pid){
80104284:	39 58 10             	cmp    %ebx,0x10(%eax)
80104287:	75 ef                	jne    80104278 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104289:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010428d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104294:	75 07                	jne    8010429d <kill+0x4d>
        p->state = RUNNABLE;
80104296:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010429d:	83 ec 0c             	sub    $0xc,%esp
801042a0:	68 c0 a5 10 80       	push   $0x8010a5c0
801042a5:	e8 96 04 00 00       	call   80104740 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042ad:	83 c4 10             	add    $0x10,%esp
801042b0:	31 c0                	xor    %eax,%eax
}
801042b2:	c9                   	leave  
801042b3:	c3                   	ret    
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 c0 a5 10 80       	push   $0x8010a5c0
801042c0:	e8 7b 04 00 00       	call   80104740 <release>
}
801042c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042c8:	83 c4 10             	add    $0x10,%esp
801042cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042d0:	c9                   	leave  
801042d1:	c3                   	ret    
801042d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042e0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042e0:	f3 0f 1e fb          	endbr32 
801042e4:	55                   	push   %ebp
801042e5:	89 e5                	mov    %esp,%ebp
801042e7:	57                   	push   %edi
801042e8:	56                   	push   %esi
801042e9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042ec:	53                   	push   %ebx
801042ed:	bb 60 a6 10 80       	mov    $0x8010a660,%ebx
801042f2:	83 ec 3c             	sub    $0x3c,%esp
801042f5:	eb 2b                	jmp    80104322 <procdump+0x42>
801042f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042fe:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 e3 7d 10 80       	push   $0x80107de3
80104308:	e8 a3 c3 ff ff       	call   801006b0 <cprintf>
8010430d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104310:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80104316:	81 fb 60 c9 10 80    	cmp    $0x8010c960,%ebx
8010431c:	0f 84 8e 00 00 00    	je     801043b0 <procdump+0xd0>
    if(p->state == UNUSED)
80104322:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104325:	85 c0                	test   %eax,%eax
80104327:	74 e7                	je     80104310 <procdump+0x30>
      state = "???";
80104329:	ba 2b 7a 10 80       	mov    $0x80107a2b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010432e:	83 f8 05             	cmp    $0x5,%eax
80104331:	77 11                	ja     80104344 <procdump+0x64>
80104333:	8b 14 85 c0 7a 10 80 	mov    -0x7fef8540(,%eax,4),%edx
      state = "???";
8010433a:	b8 2b 7a 10 80       	mov    $0x80107a2b,%eax
8010433f:	85 d2                	test   %edx,%edx
80104341:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104344:	53                   	push   %ebx
80104345:	52                   	push   %edx
80104346:	ff 73 a4             	pushl  -0x5c(%ebx)
80104349:	68 2f 7a 10 80       	push   $0x80107a2f
8010434e:	e8 5d c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104353:	83 c4 10             	add    $0x10,%esp
80104356:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010435a:	75 a4                	jne    80104300 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010435c:	83 ec 08             	sub    $0x8,%esp
8010435f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104362:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104365:	50                   	push   %eax
80104366:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104369:	8b 40 0c             	mov    0xc(%eax),%eax
8010436c:	83 c0 08             	add    $0x8,%eax
8010436f:	50                   	push   %eax
80104370:	e8 ab 01 00 00       	call   80104520 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104375:	83 c4 10             	add    $0x10,%esp
80104378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010437f:	90                   	nop
80104380:	8b 17                	mov    (%edi),%edx
80104382:	85 d2                	test   %edx,%edx
80104384:	0f 84 76 ff ff ff    	je     80104300 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010438a:	83 ec 08             	sub    $0x8,%esp
8010438d:	83 c7 04             	add    $0x4,%edi
80104390:	52                   	push   %edx
80104391:	68 81 74 10 80       	push   $0x80107481
80104396:	e8 15 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010439b:	83 c4 10             	add    $0x10,%esp
8010439e:	39 fe                	cmp    %edi,%esi
801043a0:	75 de                	jne    80104380 <procdump+0xa0>
801043a2:	e9 59 ff ff ff       	jmp    80104300 <procdump+0x20>
801043a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043ae:	66 90                	xchg   %ax,%ax
  }
}
801043b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043b3:	5b                   	pop    %ebx
801043b4:	5e                   	pop    %esi
801043b5:	5f                   	pop    %edi
801043b6:	5d                   	pop    %ebp
801043b7:	c3                   	ret    
801043b8:	66 90                	xchg   %ax,%ax
801043ba:	66 90                	xchg   %ax,%ax
801043bc:	66 90                	xchg   %ax,%ax
801043be:	66 90                	xchg   %ax,%ax

801043c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801043c0:	f3 0f 1e fb          	endbr32 
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	53                   	push   %ebx
801043c8:	83 ec 0c             	sub    $0xc,%esp
801043cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801043ce:	68 d8 7a 10 80       	push   $0x80107ad8
801043d3:	8d 43 04             	lea    0x4(%ebx),%eax
801043d6:	50                   	push   %eax
801043d7:	e8 24 01 00 00       	call   80104500 <initlock>
  lk->name = name;
801043dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801043df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801043e5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801043e8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801043ef:	89 43 38             	mov    %eax,0x38(%ebx)
}
801043f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f5:	c9                   	leave  
801043f6:	c3                   	ret    
801043f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fe:	66 90                	xchg   %ax,%ax

80104400 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	56                   	push   %esi
80104408:	53                   	push   %ebx
80104409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010440c:	8d 73 04             	lea    0x4(%ebx),%esi
8010440f:	83 ec 0c             	sub    $0xc,%esp
80104412:	56                   	push   %esi
80104413:	e8 68 02 00 00       	call   80104680 <acquire>
  while (lk->locked) {
80104418:	8b 13                	mov    (%ebx),%edx
8010441a:	83 c4 10             	add    $0x10,%esp
8010441d:	85 d2                	test   %edx,%edx
8010441f:	74 1a                	je     8010443b <acquiresleep+0x3b>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104428:	83 ec 08             	sub    $0x8,%esp
8010442b:	56                   	push   %esi
8010442c:	53                   	push   %ebx
8010442d:	e8 ee fb ff ff       	call   80104020 <sleep>
  while (lk->locked) {
80104432:	8b 03                	mov    (%ebx),%eax
80104434:	83 c4 10             	add    $0x10,%esp
80104437:	85 c0                	test   %eax,%eax
80104439:	75 ed                	jne    80104428 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010443b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104441:	e8 4a f5 ff ff       	call   80103990 <myproc>
80104446:	8b 40 10             	mov    0x10(%eax),%eax
80104449:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010444c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010444f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104452:	5b                   	pop    %ebx
80104453:	5e                   	pop    %esi
80104454:	5d                   	pop    %ebp
  release(&lk->lk);
80104455:	e9 e6 02 00 00       	jmp    80104740 <release>
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	56                   	push   %esi
80104468:	53                   	push   %ebx
80104469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010446c:	8d 73 04             	lea    0x4(%ebx),%esi
8010446f:	83 ec 0c             	sub    $0xc,%esp
80104472:	56                   	push   %esi
80104473:	e8 08 02 00 00       	call   80104680 <acquire>
  lk->locked = 0;
80104478:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010447e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104485:	89 1c 24             	mov    %ebx,(%esp)
80104488:	e8 53 fd ff ff       	call   801041e0 <wakeup>
  release(&lk->lk);
8010448d:	89 75 08             	mov    %esi,0x8(%ebp)
80104490:	83 c4 10             	add    $0x10,%esp
}
80104493:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104496:	5b                   	pop    %ebx
80104497:	5e                   	pop    %esi
80104498:	5d                   	pop    %ebp
  release(&lk->lk);
80104499:	e9 a2 02 00 00       	jmp    80104740 <release>
8010449e:	66 90                	xchg   %ax,%ax

801044a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	57                   	push   %edi
801044a8:	31 ff                	xor    %edi,%edi
801044aa:	56                   	push   %esi
801044ab:	53                   	push   %ebx
801044ac:	83 ec 18             	sub    $0x18,%esp
801044af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801044b2:	8d 73 04             	lea    0x4(%ebx),%esi
801044b5:	56                   	push   %esi
801044b6:	e8 c5 01 00 00       	call   80104680 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801044bb:	8b 03                	mov    (%ebx),%eax
801044bd:	83 c4 10             	add    $0x10,%esp
801044c0:	85 c0                	test   %eax,%eax
801044c2:	75 1c                	jne    801044e0 <holdingsleep+0x40>
  release(&lk->lk);
801044c4:	83 ec 0c             	sub    $0xc,%esp
801044c7:	56                   	push   %esi
801044c8:	e8 73 02 00 00       	call   80104740 <release>
  return r;
}
801044cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044d0:	89 f8                	mov    %edi,%eax
801044d2:	5b                   	pop    %ebx
801044d3:	5e                   	pop    %esi
801044d4:	5f                   	pop    %edi
801044d5:	5d                   	pop    %ebp
801044d6:	c3                   	ret    
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801044e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801044e3:	e8 a8 f4 ff ff       	call   80103990 <myproc>
801044e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801044eb:	0f 94 c0             	sete   %al
801044ee:	0f b6 c0             	movzbl %al,%eax
801044f1:	89 c7                	mov    %eax,%edi
801044f3:	eb cf                	jmp    801044c4 <holdingsleep+0x24>
801044f5:	66 90                	xchg   %ax,%ax
801044f7:	66 90                	xchg   %ax,%ax
801044f9:	66 90                	xchg   %ax,%ax
801044fb:	66 90                	xchg   %ax,%ax
801044fd:	66 90                	xchg   %ax,%ax
801044ff:	90                   	nop

80104500 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104500:	f3 0f 1e fb          	endbr32 
80104504:	55                   	push   %ebp
80104505:	89 e5                	mov    %esp,%ebp
80104507:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010450a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010450d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104513:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104516:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010451d:	5d                   	pop    %ebp
8010451e:	c3                   	ret    
8010451f:	90                   	nop

80104520 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104525:	31 d2                	xor    %edx,%edx
{
80104527:	89 e5                	mov    %esp,%ebp
80104529:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010452a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010452d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104530:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104537:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104538:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010453e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104544:	77 1a                	ja     80104560 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104546:	8b 58 04             	mov    0x4(%eax),%ebx
80104549:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010454c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010454f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104551:	83 fa 0a             	cmp    $0xa,%edx
80104554:	75 e2                	jne    80104538 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104556:	5b                   	pop    %ebx
80104557:	5d                   	pop    %ebp
80104558:	c3                   	ret    
80104559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104560:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104563:	8d 51 28             	lea    0x28(%ecx),%edx
80104566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010456d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104576:	83 c0 04             	add    $0x4,%eax
80104579:	39 d0                	cmp    %edx,%eax
8010457b:	75 f3                	jne    80104570 <getcallerpcs+0x50>
}
8010457d:	5b                   	pop    %ebx
8010457e:	5d                   	pop    %ebp
8010457f:	c3                   	ret    

80104580 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104580:	f3 0f 1e fb          	endbr32 
80104584:	55                   	push   %ebp
80104585:	89 e5                	mov    %esp,%ebp
80104587:	53                   	push   %ebx
80104588:	83 ec 04             	sub    $0x4,%esp
8010458b:	9c                   	pushf  
8010458c:	5b                   	pop    %ebx
  asm volatile("cli");
8010458d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010458e:	e8 6d f3 ff ff       	call   80103900 <mycpu>
80104593:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104599:	85 c0                	test   %eax,%eax
8010459b:	74 13                	je     801045b0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010459d:	e8 5e f3 ff ff       	call   80103900 <mycpu>
801045a2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801045a9:	83 c4 04             	add    $0x4,%esp
801045ac:	5b                   	pop    %ebx
801045ad:	5d                   	pop    %ebp
801045ae:	c3                   	ret    
801045af:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801045b0:	e8 4b f3 ff ff       	call   80103900 <mycpu>
801045b5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801045bb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801045c1:	eb da                	jmp    8010459d <pushcli+0x1d>
801045c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045da:	9c                   	pushf  
801045db:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045dc:	f6 c4 02             	test   $0x2,%ah
801045df:	75 31                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045e1:	e8 1a f3 ff ff       	call   80103900 <mycpu>
801045e6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045ed:	78 30                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045ef:	e8 0c f3 ff ff       	call   80103900 <mycpu>
801045f4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045fa:	85 d2                	test   %edx,%edx
801045fc:	74 02                	je     80104600 <popcli+0x30>
    sti();
}
801045fe:	c9                   	leave  
801045ff:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 fb f2 ff ff       	call   80103900 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 ef                	je     801045fe <popcli+0x2e>
  asm volatile("sti");
8010460f:	fb                   	sti    
}
80104610:	c9                   	leave  
80104611:	c3                   	ret    
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 e3 7a 10 80       	push   $0x80107ae3
8010461a:	e8 71 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 fa 7a 10 80       	push   $0x80107afa
80104627:	e8 64 bd ff ff       	call   80100390 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <holding>:
{
80104630:	f3 0f 1e fb          	endbr32 
80104634:	55                   	push   %ebp
80104635:	89 e5                	mov    %esp,%ebp
80104637:	56                   	push   %esi
80104638:	53                   	push   %ebx
80104639:	8b 75 08             	mov    0x8(%ebp),%esi
8010463c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010463e:	e8 3d ff ff ff       	call   80104580 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104643:	8b 06                	mov    (%esi),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	75 0f                	jne    80104658 <holding+0x28>
  popcli();
80104649:	e8 82 ff ff ff       	call   801045d0 <popcli>
}
8010464e:	89 d8                	mov    %ebx,%eax
80104650:	5b                   	pop    %ebx
80104651:	5e                   	pop    %esi
80104652:	5d                   	pop    %ebp
80104653:	c3                   	ret    
80104654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104658:	8b 5e 08             	mov    0x8(%esi),%ebx
8010465b:	e8 a0 f2 ff ff       	call   80103900 <mycpu>
80104660:	39 c3                	cmp    %eax,%ebx
80104662:	0f 94 c3             	sete   %bl
  popcli();
80104665:	e8 66 ff ff ff       	call   801045d0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010466a:	0f b6 db             	movzbl %bl,%ebx
}
8010466d:	89 d8                	mov    %ebx,%eax
8010466f:	5b                   	pop    %ebx
80104670:	5e                   	pop    %esi
80104671:	5d                   	pop    %ebp
80104672:	c3                   	ret    
80104673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104680 <acquire>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	56                   	push   %esi
80104688:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104689:	e8 f2 fe ff ff       	call   80104580 <pushcli>
  if(holding(lk))
8010468e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104691:	83 ec 0c             	sub    $0xc,%esp
80104694:	53                   	push   %ebx
80104695:	e8 96 ff ff ff       	call   80104630 <holding>
8010469a:	83 c4 10             	add    $0x10,%esp
8010469d:	85 c0                	test   %eax,%eax
8010469f:	0f 85 7f 00 00 00    	jne    80104724 <acquire+0xa4>
801046a5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801046a7:	ba 01 00 00 00       	mov    $0x1,%edx
801046ac:	eb 05                	jmp    801046b3 <acquire+0x33>
801046ae:	66 90                	xchg   %ax,%ax
801046b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046b3:	89 d0                	mov    %edx,%eax
801046b5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801046b8:	85 c0                	test   %eax,%eax
801046ba:	75 f4                	jne    801046b0 <acquire+0x30>
  __sync_synchronize();
801046bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046c4:	e8 37 f2 ff ff       	call   80103900 <mycpu>
801046c9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801046cc:	89 e8                	mov    %ebp,%eax
801046ce:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046d0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801046d6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801046dc:	77 22                	ja     80104700 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801046de:	8b 50 04             	mov    0x4(%eax),%edx
801046e1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801046e5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801046e8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046ea:	83 fe 0a             	cmp    $0xa,%esi
801046ed:	75 e1                	jne    801046d0 <acquire+0x50>
}
801046ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046f2:	5b                   	pop    %ebx
801046f3:	5e                   	pop    %esi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
801046f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104700:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104704:	83 c3 34             	add    $0x34,%ebx
80104707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010470e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104710:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104716:	83 c0 04             	add    $0x4,%eax
80104719:	39 d8                	cmp    %ebx,%eax
8010471b:	75 f3                	jne    80104710 <acquire+0x90>
}
8010471d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104720:	5b                   	pop    %ebx
80104721:	5e                   	pop    %esi
80104722:	5d                   	pop    %ebp
80104723:	c3                   	ret    
    panic("acquire");
80104724:	83 ec 0c             	sub    $0xc,%esp
80104727:	68 01 7b 10 80       	push   $0x80107b01
8010472c:	e8 5f bc ff ff       	call   80100390 <panic>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473f:	90                   	nop

80104740 <release>:
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	53                   	push   %ebx
80104748:	83 ec 10             	sub    $0x10,%esp
8010474b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010474e:	53                   	push   %ebx
8010474f:	e8 dc fe ff ff       	call   80104630 <holding>
80104754:	83 c4 10             	add    $0x10,%esp
80104757:	85 c0                	test   %eax,%eax
80104759:	74 22                	je     8010477d <release+0x3d>
  lk->pcs[0] = 0;
8010475b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104762:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104769:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010476e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104777:	c9                   	leave  
  popcli();
80104778:	e9 53 fe ff ff       	jmp    801045d0 <popcli>
    panic("release");
8010477d:	83 ec 0c             	sub    $0xc,%esp
80104780:	68 09 7b 10 80       	push   $0x80107b09
80104785:	e8 06 bc ff ff       	call   80100390 <panic>
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	57                   	push   %edi
80104798:	8b 55 08             	mov    0x8(%ebp),%edx
8010479b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010479e:	53                   	push   %ebx
8010479f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801047a2:	89 d7                	mov    %edx,%edi
801047a4:	09 cf                	or     %ecx,%edi
801047a6:	83 e7 03             	and    $0x3,%edi
801047a9:	75 25                	jne    801047d0 <memset+0x40>
    c &= 0xFF;
801047ab:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047ae:	c1 e0 18             	shl    $0x18,%eax
801047b1:	89 fb                	mov    %edi,%ebx
801047b3:	c1 e9 02             	shr    $0x2,%ecx
801047b6:	c1 e3 10             	shl    $0x10,%ebx
801047b9:	09 d8                	or     %ebx,%eax
801047bb:	09 f8                	or     %edi,%eax
801047bd:	c1 e7 08             	shl    $0x8,%edi
801047c0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047c2:	89 d7                	mov    %edx,%edi
801047c4:	fc                   	cld    
801047c5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047c7:	5b                   	pop    %ebx
801047c8:	89 d0                	mov    %edx,%eax
801047ca:	5f                   	pop    %edi
801047cb:	5d                   	pop    %ebp
801047cc:	c3                   	ret    
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
801047d0:	89 d7                	mov    %edx,%edi
801047d2:	fc                   	cld    
801047d3:	f3 aa                	rep stos %al,%es:(%edi)
801047d5:	5b                   	pop    %ebx
801047d6:	89 d0                	mov    %edx,%eax
801047d8:	5f                   	pop    %edi
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    
801047db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047df:	90                   	nop

801047e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 75 10             	mov    0x10(%ebp),%esi
801047eb:	8b 55 08             	mov    0x8(%ebp),%edx
801047ee:	53                   	push   %ebx
801047ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047f2:	85 f6                	test   %esi,%esi
801047f4:	74 2a                	je     80104820 <memcmp+0x40>
801047f6:	01 c6                	add    %eax,%esi
801047f8:	eb 10                	jmp    8010480a <memcmp+0x2a>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104800:	83 c0 01             	add    $0x1,%eax
80104803:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104806:	39 f0                	cmp    %esi,%eax
80104808:	74 16                	je     80104820 <memcmp+0x40>
    if(*s1 != *s2)
8010480a:	0f b6 0a             	movzbl (%edx),%ecx
8010480d:	0f b6 18             	movzbl (%eax),%ebx
80104810:	38 d9                	cmp    %bl,%cl
80104812:	74 ec                	je     80104800 <memcmp+0x20>
      return *s1 - *s2;
80104814:	0f b6 c1             	movzbl %cl,%eax
80104817:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi
80104820:	5b                   	pop    %ebx
  return 0;
80104821:	31 c0                	xor    %eax,%eax
}
80104823:	5e                   	pop    %esi
80104824:	5d                   	pop    %ebp
80104825:	c3                   	ret    
80104826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482d:	8d 76 00             	lea    0x0(%esi),%esi

80104830 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	8b 55 08             	mov    0x8(%ebp),%edx
8010483b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010483e:	56                   	push   %esi
8010483f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104842:	39 d6                	cmp    %edx,%esi
80104844:	73 2a                	jae    80104870 <memmove+0x40>
80104846:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104849:	39 fa                	cmp    %edi,%edx
8010484b:	73 23                	jae    80104870 <memmove+0x40>
8010484d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104850:	85 c9                	test   %ecx,%ecx
80104852:	74 13                	je     80104867 <memmove+0x37>
80104854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104858:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010485c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010485f:	83 e8 01             	sub    $0x1,%eax
80104862:	83 f8 ff             	cmp    $0xffffffff,%eax
80104865:	75 f1                	jne    80104858 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104867:	5e                   	pop    %esi
80104868:	89 d0                	mov    %edx,%eax
8010486a:	5f                   	pop    %edi
8010486b:	5d                   	pop    %ebp
8010486c:	c3                   	ret    
8010486d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104870:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104873:	89 d7                	mov    %edx,%edi
80104875:	85 c9                	test   %ecx,%ecx
80104877:	74 ee                	je     80104867 <memmove+0x37>
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104880:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104881:	39 f0                	cmp    %esi,%eax
80104883:	75 fb                	jne    80104880 <memmove+0x50>
}
80104885:	5e                   	pop    %esi
80104886:	89 d0                	mov    %edx,%eax
80104888:	5f                   	pop    %edi
80104889:	5d                   	pop    %ebp
8010488a:	c3                   	ret    
8010488b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010488f:	90                   	nop

80104890 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104890:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104894:	eb 9a                	jmp    80104830 <memmove>
80104896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489d:	8d 76 00             	lea    0x0(%esi),%esi

801048a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	8b 75 10             	mov    0x10(%ebp),%esi
801048ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048ae:	53                   	push   %ebx
801048af:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801048b2:	85 f6                	test   %esi,%esi
801048b4:	74 32                	je     801048e8 <strncmp+0x48>
801048b6:	01 c6                	add    %eax,%esi
801048b8:	eb 14                	jmp    801048ce <strncmp+0x2e>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048c0:	38 da                	cmp    %bl,%dl
801048c2:	75 14                	jne    801048d8 <strncmp+0x38>
    n--, p++, q++;
801048c4:	83 c0 01             	add    $0x1,%eax
801048c7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048ca:	39 f0                	cmp    %esi,%eax
801048cc:	74 1a                	je     801048e8 <strncmp+0x48>
801048ce:	0f b6 11             	movzbl (%ecx),%edx
801048d1:	0f b6 18             	movzbl (%eax),%ebx
801048d4:	84 d2                	test   %dl,%dl
801048d6:	75 e8                	jne    801048c0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048d8:	0f b6 c2             	movzbl %dl,%eax
801048db:	29 d8                	sub    %ebx,%eax
}
801048dd:	5b                   	pop    %ebx
801048de:	5e                   	pop    %esi
801048df:	5d                   	pop    %ebp
801048e0:	c3                   	ret    
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	5b                   	pop    %ebx
    return 0;
801048e9:	31 c0                	xor    %eax,%eax
}
801048eb:	5e                   	pop    %esi
801048ec:	5d                   	pop    %ebp
801048ed:	c3                   	ret    
801048ee:	66 90                	xchg   %ax,%ax

801048f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	57                   	push   %edi
801048f8:	56                   	push   %esi
801048f9:	8b 75 08             	mov    0x8(%ebp),%esi
801048fc:	53                   	push   %ebx
801048fd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104900:	89 f2                	mov    %esi,%edx
80104902:	eb 1b                	jmp    8010491f <strncpy+0x2f>
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104908:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010490c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010490f:	83 c2 01             	add    $0x1,%edx
80104912:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104916:	89 f9                	mov    %edi,%ecx
80104918:	88 4a ff             	mov    %cl,-0x1(%edx)
8010491b:	84 c9                	test   %cl,%cl
8010491d:	74 09                	je     80104928 <strncpy+0x38>
8010491f:	89 c3                	mov    %eax,%ebx
80104921:	83 e8 01             	sub    $0x1,%eax
80104924:	85 db                	test   %ebx,%ebx
80104926:	7f e0                	jg     80104908 <strncpy+0x18>
    ;
  while(n-- > 0)
80104928:	89 d1                	mov    %edx,%ecx
8010492a:	85 c0                	test   %eax,%eax
8010492c:	7e 15                	jle    80104943 <strncpy+0x53>
8010492e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104930:	83 c1 01             	add    $0x1,%ecx
80104933:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104937:	89 c8                	mov    %ecx,%eax
80104939:	f7 d0                	not    %eax
8010493b:	01 d0                	add    %edx,%eax
8010493d:	01 d8                	add    %ebx,%eax
8010493f:	85 c0                	test   %eax,%eax
80104941:	7f ed                	jg     80104930 <strncpy+0x40>
  return os;
}
80104943:	5b                   	pop    %ebx
80104944:	89 f0                	mov    %esi,%eax
80104946:	5e                   	pop    %esi
80104947:	5f                   	pop    %edi
80104948:	5d                   	pop    %ebp
80104949:	c3                   	ret    
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104950 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	8b 55 10             	mov    0x10(%ebp),%edx
8010495b:	8b 75 08             	mov    0x8(%ebp),%esi
8010495e:	53                   	push   %ebx
8010495f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104962:	85 d2                	test   %edx,%edx
80104964:	7e 21                	jle    80104987 <safestrcpy+0x37>
80104966:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010496a:	89 f2                	mov    %esi,%edx
8010496c:	eb 12                	jmp    80104980 <safestrcpy+0x30>
8010496e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104970:	0f b6 08             	movzbl (%eax),%ecx
80104973:	83 c0 01             	add    $0x1,%eax
80104976:	83 c2 01             	add    $0x1,%edx
80104979:	88 4a ff             	mov    %cl,-0x1(%edx)
8010497c:	84 c9                	test   %cl,%cl
8010497e:	74 04                	je     80104984 <safestrcpy+0x34>
80104980:	39 d8                	cmp    %ebx,%eax
80104982:	75 ec                	jne    80104970 <safestrcpy+0x20>
    ;
  *s = 0;
80104984:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104987:	89 f0                	mov    %esi,%eax
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi

80104990 <strlen>:

int
strlen(const char *s)
{
80104990:	f3 0f 1e fb          	endbr32 
80104994:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104995:	31 c0                	xor    %eax,%eax
{
80104997:	89 e5                	mov    %esp,%ebp
80104999:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010499c:	80 3a 00             	cmpb   $0x0,(%edx)
8010499f:	74 10                	je     801049b1 <strlen+0x21>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	83 c0 01             	add    $0x1,%eax
801049ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049af:	75 f7                	jne    801049a8 <strlen+0x18>
    ;
  return n;
}
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    

801049b3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049b3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049b7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049bb:	55                   	push   %ebp
  pushl %ebx
801049bc:	53                   	push   %ebx
  pushl %esi
801049bd:	56                   	push   %esi
  pushl %edi
801049be:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049bf:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049c1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049c3:	5f                   	pop    %edi
  popl %esi
801049c4:	5e                   	pop    %esi
  popl %ebx
801049c5:	5b                   	pop    %ebx
  popl %ebp
801049c6:	5d                   	pop    %ebp
  ret
801049c7:	c3                   	ret    
801049c8:	66 90                	xchg   %ax,%ax
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049d0:	f3 0f 1e fb          	endbr32 
801049d4:	55                   	push   %ebp
801049d5:	89 e5                	mov    %esp,%ebp
801049d7:	53                   	push   %ebx
801049d8:	83 ec 04             	sub    $0x4,%esp
801049db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049de:	e8 ad ef ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049e3:	8b 00                	mov    (%eax),%eax
801049e5:	39 d8                	cmp    %ebx,%eax
801049e7:	76 17                	jbe    80104a00 <fetchint+0x30>
801049e9:	8d 53 04             	lea    0x4(%ebx),%edx
801049ec:	39 d0                	cmp    %edx,%eax
801049ee:	72 10                	jb     80104a00 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049f3:	8b 13                	mov    (%ebx),%edx
801049f5:	89 10                	mov    %edx,(%eax)
  return 0;
801049f7:	31 c0                	xor    %eax,%eax
}
801049f9:	83 c4 04             	add    $0x4,%esp
801049fc:	5b                   	pop    %ebx
801049fd:	5d                   	pop    %ebp
801049fe:	c3                   	ret    
801049ff:	90                   	nop
    return -1;
80104a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a05:	eb f2                	jmp    801049f9 <fetchint+0x29>
80104a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a0e:	66 90                	xchg   %ax,%ax

80104a10 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	53                   	push   %ebx
80104a18:	83 ec 04             	sub    $0x4,%esp
80104a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a1e:	e8 6d ef ff ff       	call   80103990 <myproc>

  if(addr >= curproc->sz)
80104a23:	39 18                	cmp    %ebx,(%eax)
80104a25:	76 31                	jbe    80104a58 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104a27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a2e:	39 d3                	cmp    %edx,%ebx
80104a30:	73 26                	jae    80104a58 <fetchstr+0x48>
80104a32:	89 d8                	mov    %ebx,%eax
80104a34:	eb 11                	jmp    80104a47 <fetchstr+0x37>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	39 c2                	cmp    %eax,%edx
80104a45:	76 11                	jbe    80104a58 <fetchstr+0x48>
    if(*s == 0)
80104a47:	80 38 00             	cmpb   $0x0,(%eax)
80104a4a:	75 f4                	jne    80104a40 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a4c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104a4f:	29 d8                	sub    %ebx,%eax
}
80104a51:	5b                   	pop    %ebx
80104a52:	5d                   	pop    %ebp
80104a53:	c3                   	ret    
80104a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a58:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a60:	5b                   	pop    %ebx
80104a61:	5d                   	pop    %ebp
80104a62:	c3                   	ret    
80104a63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	56                   	push   %esi
80104a78:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a79:	e8 12 ef ff ff       	call   80103990 <myproc>
80104a7e:	8b 55 08             	mov    0x8(%ebp),%edx
80104a81:	8b 40 18             	mov    0x18(%eax),%eax
80104a84:	8b 40 44             	mov    0x44(%eax),%eax
80104a87:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a8a:	e8 01 ef ff ff       	call   80103990 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a8f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a92:	8b 00                	mov    (%eax),%eax
80104a94:	39 c6                	cmp    %eax,%esi
80104a96:	73 18                	jae    80104ab0 <argint+0x40>
80104a98:	8d 53 08             	lea    0x8(%ebx),%edx
80104a9b:	39 d0                	cmp    %edx,%eax
80104a9d:	72 11                	jb     80104ab0 <argint+0x40>
  *ip = *(int*)(addr);
80104a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa2:	8b 53 04             	mov    0x4(%ebx),%edx
80104aa5:	89 10                	mov    %edx,(%eax)
  return 0;
80104aa7:	31 c0                	xor    %eax,%eax
}
80104aa9:	5b                   	pop    %ebx
80104aaa:	5e                   	pop    %esi
80104aab:	5d                   	pop    %ebp
80104aac:	c3                   	ret    
80104aad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab5:	eb f2                	jmp    80104aa9 <argint+0x39>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ac0:	f3 0f 1e fb          	endbr32 
80104ac4:	55                   	push   %ebp
80104ac5:	89 e5                	mov    %esp,%ebp
80104ac7:	56                   	push   %esi
80104ac8:	53                   	push   %ebx
80104ac9:	83 ec 10             	sub    $0x10,%esp
80104acc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104acf:	e8 bc ee ff ff       	call   80103990 <myproc>
 
  if(argint(n, &i) < 0)
80104ad4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104ad7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104adc:	50                   	push   %eax
80104add:	ff 75 08             	pushl  0x8(%ebp)
80104ae0:	e8 8b ff ff ff       	call   80104a70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ae5:	83 c4 10             	add    $0x10,%esp
80104ae8:	85 c0                	test   %eax,%eax
80104aea:	78 24                	js     80104b10 <argptr+0x50>
80104aec:	85 db                	test   %ebx,%ebx
80104aee:	78 20                	js     80104b10 <argptr+0x50>
80104af0:	8b 16                	mov    (%esi),%edx
80104af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af5:	39 c2                	cmp    %eax,%edx
80104af7:	76 17                	jbe    80104b10 <argptr+0x50>
80104af9:	01 c3                	add    %eax,%ebx
80104afb:	39 da                	cmp    %ebx,%edx
80104afd:	72 11                	jb     80104b10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104aff:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b02:	89 02                	mov    %eax,(%edx)
  return 0;
80104b04:	31 c0                	xor    %eax,%eax
}
80104b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b09:	5b                   	pop    %ebx
80104b0a:	5e                   	pop    %esi
80104b0b:	5d                   	pop    %ebp
80104b0c:	c3                   	ret    
80104b0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b15:	eb ef                	jmp    80104b06 <argptr+0x46>
80104b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1e:	66 90                	xchg   %ax,%ax

80104b20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b20:	f3 0f 1e fb          	endbr32 
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b2d:	50                   	push   %eax
80104b2e:	ff 75 08             	pushl  0x8(%ebp)
80104b31:	e8 3a ff ff ff       	call   80104a70 <argint>
80104b36:	83 c4 10             	add    $0x10,%esp
80104b39:	85 c0                	test   %eax,%eax
80104b3b:	78 13                	js     80104b50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b3d:	83 ec 08             	sub    $0x8,%esp
80104b40:	ff 75 0c             	pushl  0xc(%ebp)
80104b43:	ff 75 f4             	pushl  -0xc(%ebp)
80104b46:	e8 c5 fe ff ff       	call   80104a10 <fetchstr>
80104b4b:	83 c4 10             	add    $0x10,%esp
}
80104b4e:	c9                   	leave  
80104b4f:	c3                   	ret    
80104b50:	c9                   	leave  
    return -1;
80104b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b56:	c3                   	ret    
80104b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5e:	66 90                	xchg   %ax,%ax

80104b60 <syscall>:

int readcount_global = 0;

void
syscall(void)
{
80104b60:	f3 0f 1e fb          	endbr32 
80104b64:	55                   	push   %ebp
80104b65:	89 e5                	mov    %esp,%ebp
80104b67:	53                   	push   %ebx
80104b68:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b6b:	e8 20 ee ff ff       	call   80103990 <myproc>
80104b70:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b72:	8b 40 18             	mov    0x18(%eax),%eax
80104b75:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num == SYS_read){
80104b78:	83 f8 05             	cmp    $0x5,%eax
80104b7b:	74 53                	je     80104bd0 <syscall+0x70>
    curproc->readcount++;
    readcount_global++;
  }
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b7d:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b80:	83 fa 17             	cmp    $0x17,%edx
80104b83:	76 2b                	jbe    80104bb0 <syscall+0x50>
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104b85:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104b86:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104b89:	50                   	push   %eax
80104b8a:	ff 73 10             	pushl  0x10(%ebx)
80104b8d:	68 11 7b 10 80       	push   $0x80107b11
80104b92:	e8 19 bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104b97:	8b 43 18             	mov    0x18(%ebx),%eax
80104b9a:	83 c4 10             	add    $0x10,%esp
80104b9d:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba7:	c9                   	leave  
80104ba8:	c3                   	ret    
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bb0:	8b 14 85 40 7b 10 80 	mov    -0x7fef84c0(,%eax,4),%edx
80104bb7:	85 d2                	test   %edx,%edx
80104bb9:	74 ca                	je     80104b85 <syscall+0x25>
    curproc->tf->eax = syscalls[num]();
80104bbb:	ff d2                	call   *%edx
80104bbd:	89 c2                	mov    %eax,%edx
80104bbf:	8b 43 18             	mov    0x18(%ebx),%eax
80104bc2:	89 50 1c             	mov    %edx,0x1c(%eax)
}
80104bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc8:	c9                   	leave  
80104bc9:	c3                   	ret    
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104bd0:	ba 50 4e 10 80       	mov    $0x80104e50,%edx
    curproc->readcount++;
80104bd5:	83 43 7c 01          	addl   $0x1,0x7c(%ebx)
    readcount_global++;
80104bd9:	83 05 f8 c8 10 80 01 	addl   $0x1,0x8010c8f8
    curproc->tf->eax = syscalls[num]();
80104be0:	ff d2                	call   *%edx
80104be2:	89 c2                	mov    %eax,%edx
80104be4:	8b 43 18             	mov    0x18(%ebx),%eax
80104be7:	89 50 1c             	mov    %edx,0x1c(%eax)
80104bea:	eb d9                	jmp    80104bc5 <syscall+0x65>
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bf5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104bf8:	53                   	push   %ebx
80104bf9:	83 ec 34             	sub    $0x34,%esp
80104bfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104c02:	57                   	push   %edi
80104c03:	50                   	push   %eax
{
80104c04:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c07:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c0a:	e8 41 d4 ff ff       	call   80102050 <nameiparent>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	0f 84 46 01 00 00    	je     80104d60 <create+0x170>
    return 0;
  ilock(dp);
80104c1a:	83 ec 0c             	sub    $0xc,%esp
80104c1d:	89 c3                	mov    %eax,%ebx
80104c1f:	50                   	push   %eax
80104c20:	e8 3b cb ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c25:	83 c4 0c             	add    $0xc,%esp
80104c28:	6a 00                	push   $0x0
80104c2a:	57                   	push   %edi
80104c2b:	53                   	push   %ebx
80104c2c:	e8 7f d0 ff ff       	call   80101cb0 <dirlookup>
80104c31:	83 c4 10             	add    $0x10,%esp
80104c34:	89 c6                	mov    %eax,%esi
80104c36:	85 c0                	test   %eax,%eax
80104c38:	74 56                	je     80104c90 <create+0xa0>
    iunlockput(dp);
80104c3a:	83 ec 0c             	sub    $0xc,%esp
80104c3d:	53                   	push   %ebx
80104c3e:	e8 bd cd ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104c43:	89 34 24             	mov    %esi,(%esp)
80104c46:	e8 15 cb ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c4b:	83 c4 10             	add    $0x10,%esp
80104c4e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c53:	75 1b                	jne    80104c70 <create+0x80>
80104c55:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c5a:	75 14                	jne    80104c70 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c5f:	89 f0                	mov    %esi,%eax
80104c61:	5b                   	pop    %ebx
80104c62:	5e                   	pop    %esi
80104c63:	5f                   	pop    %edi
80104c64:	5d                   	pop    %ebp
80104c65:	c3                   	ret    
80104c66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c6d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c70:	83 ec 0c             	sub    $0xc,%esp
80104c73:	56                   	push   %esi
    return 0;
80104c74:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104c76:	e8 85 cd ff ff       	call   80101a00 <iunlockput>
    return 0;
80104c7b:	83 c4 10             	add    $0x10,%esp
}
80104c7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c81:	89 f0                	mov    %esi,%eax
80104c83:	5b                   	pop    %ebx
80104c84:	5e                   	pop    %esi
80104c85:	5f                   	pop    %edi
80104c86:	5d                   	pop    %ebp
80104c87:	c3                   	ret    
80104c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104c90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	50                   	push   %eax
80104c98:	ff 33                	pushl  (%ebx)
80104c9a:	e8 41 c9 ff ff       	call   801015e0 <ialloc>
80104c9f:	83 c4 10             	add    $0x10,%esp
80104ca2:	89 c6                	mov    %eax,%esi
80104ca4:	85 c0                	test   %eax,%eax
80104ca6:	0f 84 cd 00 00 00    	je     80104d79 <create+0x189>
  ilock(ip);
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	50                   	push   %eax
80104cb0:	e8 ab ca ff ff       	call   80101760 <ilock>
  ip->major = major;
80104cb5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104cb9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cbd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cc1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cc5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cca:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cce:	89 34 24             	mov    %esi,(%esp)
80104cd1:	e8 ca c9 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cd6:	83 c4 10             	add    $0x10,%esp
80104cd9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cde:	74 30                	je     80104d10 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ce0:	83 ec 04             	sub    $0x4,%esp
80104ce3:	ff 76 04             	pushl  0x4(%esi)
80104ce6:	57                   	push   %edi
80104ce7:	53                   	push   %ebx
80104ce8:	e8 83 d2 ff ff       	call   80101f70 <dirlink>
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	78 78                	js     80104d6c <create+0x17c>
  iunlockput(dp);
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	53                   	push   %ebx
80104cf8:	e8 03 cd ff ff       	call   80101a00 <iunlockput>
  return ip;
80104cfd:	83 c4 10             	add    $0x10,%esp
}
80104d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d03:	89 f0                	mov    %esi,%eax
80104d05:	5b                   	pop    %ebx
80104d06:	5e                   	pop    %esi
80104d07:	5f                   	pop    %edi
80104d08:	5d                   	pop    %ebp
80104d09:	c3                   	ret    
80104d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d10:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d13:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d18:	53                   	push   %ebx
80104d19:	e8 82 c9 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d1e:	83 c4 0c             	add    $0xc,%esp
80104d21:	ff 76 04             	pushl  0x4(%esi)
80104d24:	68 c0 7b 10 80       	push   $0x80107bc0
80104d29:	56                   	push   %esi
80104d2a:	e8 41 d2 ff ff       	call   80101f70 <dirlink>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	85 c0                	test   %eax,%eax
80104d34:	78 18                	js     80104d4e <create+0x15e>
80104d36:	83 ec 04             	sub    $0x4,%esp
80104d39:	ff 73 04             	pushl  0x4(%ebx)
80104d3c:	68 bf 7b 10 80       	push   $0x80107bbf
80104d41:	56                   	push   %esi
80104d42:	e8 29 d2 ff ff       	call   80101f70 <dirlink>
80104d47:	83 c4 10             	add    $0x10,%esp
80104d4a:	85 c0                	test   %eax,%eax
80104d4c:	79 92                	jns    80104ce0 <create+0xf0>
      panic("create dots");
80104d4e:	83 ec 0c             	sub    $0xc,%esp
80104d51:	68 b3 7b 10 80       	push   $0x80107bb3
80104d56:	e8 35 b6 ff ff       	call   80100390 <panic>
80104d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d5f:	90                   	nop
}
80104d60:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d63:	31 f6                	xor    %esi,%esi
}
80104d65:	5b                   	pop    %ebx
80104d66:	89 f0                	mov    %esi,%eax
80104d68:	5e                   	pop    %esi
80104d69:	5f                   	pop    %edi
80104d6a:	5d                   	pop    %ebp
80104d6b:	c3                   	ret    
    panic("create: dirlink");
80104d6c:	83 ec 0c             	sub    $0xc,%esp
80104d6f:	68 c2 7b 10 80       	push   $0x80107bc2
80104d74:	e8 17 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104d79:	83 ec 0c             	sub    $0xc,%esp
80104d7c:	68 a4 7b 10 80       	push   $0x80107ba4
80104d81:	e8 0a b6 ff ff       	call   80100390 <panic>
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	56                   	push   %esi
80104d94:	89 d6                	mov    %edx,%esi
80104d96:	53                   	push   %ebx
80104d97:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104d99:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d9c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d9f:	50                   	push   %eax
80104da0:	6a 00                	push   $0x0
80104da2:	e8 c9 fc ff ff       	call   80104a70 <argint>
80104da7:	83 c4 10             	add    $0x10,%esp
80104daa:	85 c0                	test   %eax,%eax
80104dac:	78 2a                	js     80104dd8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104db2:	77 24                	ja     80104dd8 <argfd.constprop.0+0x48>
80104db4:	e8 d7 eb ff ff       	call   80103990 <myproc>
80104db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dbc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	74 14                	je     80104dd8 <argfd.constprop.0+0x48>
  if(pfd)
80104dc4:	85 db                	test   %ebx,%ebx
80104dc6:	74 02                	je     80104dca <argfd.constprop.0+0x3a>
    *pfd = fd;
80104dc8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104dca:	89 06                	mov    %eax,(%esi)
  return 0;
80104dcc:	31 c0                	xor    %eax,%eax
}
80104dce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd1:	5b                   	pop    %ebx
80104dd2:	5e                   	pop    %esi
80104dd3:	5d                   	pop    %ebp
80104dd4:	c3                   	ret    
80104dd5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104dd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ddd:	eb ef                	jmp    80104dce <argfd.constprop.0+0x3e>
80104ddf:	90                   	nop

80104de0 <sys_dup>:
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104de5:	31 c0                	xor    %eax,%eax
{
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	56                   	push   %esi
80104dea:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104deb:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104dee:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104df1:	e8 9a ff ff ff       	call   80104d90 <argfd.constprop.0>
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 1e                	js     80104e18 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104dfa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104dfd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104dff:	e8 8c eb ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104e08:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104e0c:	85 d2                	test   %edx,%edx
80104e0e:	74 20                	je     80104e30 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104e10:	83 c3 01             	add    $0x1,%ebx
80104e13:	83 fb 10             	cmp    $0x10,%ebx
80104e16:	75 f0                	jne    80104e08 <sys_dup+0x28>
}
80104e18:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104e1b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104e20:	89 d8                	mov    %ebx,%eax
80104e22:	5b                   	pop    %ebx
80104e23:	5e                   	pop    %esi
80104e24:	5d                   	pop    %ebp
80104e25:	c3                   	ret    
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104e30:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	ff 75 f4             	pushl  -0xc(%ebp)
80104e3a:	e8 31 c0 ff ff       	call   80100e70 <filedup>
  return fd;
80104e3f:	83 c4 10             	add    $0x10,%esp
}
80104e42:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e45:	89 d8                	mov    %ebx,%eax
80104e47:	5b                   	pop    %ebx
80104e48:	5e                   	pop    %esi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    
80104e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e4f:	90                   	nop

80104e50 <sys_read>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e55:	31 c0                	xor    %eax,%eax
{
80104e57:	89 e5                	mov    %esp,%ebp
80104e59:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e5c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5f:	e8 2c ff ff ff       	call   80104d90 <argfd.constprop.0>
80104e64:	85 c0                	test   %eax,%eax
80104e66:	78 48                	js     80104eb0 <sys_read+0x60>
80104e68:	83 ec 08             	sub    $0x8,%esp
80104e6b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e6e:	50                   	push   %eax
80104e6f:	6a 02                	push   $0x2
80104e71:	e8 fa fb ff ff       	call   80104a70 <argint>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	85 c0                	test   %eax,%eax
80104e7b:	78 33                	js     80104eb0 <sys_read+0x60>
80104e7d:	83 ec 04             	sub    $0x4,%esp
80104e80:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e83:	ff 75 f0             	pushl  -0x10(%ebp)
80104e86:	50                   	push   %eax
80104e87:	6a 01                	push   $0x1
80104e89:	e8 32 fc ff ff       	call   80104ac0 <argptr>
80104e8e:	83 c4 10             	add    $0x10,%esp
80104e91:	85 c0                	test   %eax,%eax
80104e93:	78 1b                	js     80104eb0 <sys_read+0x60>
  return fileread(f, p, n);
80104e95:	83 ec 04             	sub    $0x4,%esp
80104e98:	ff 75 f0             	pushl  -0x10(%ebp)
80104e9b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9e:	ff 75 ec             	pushl  -0x14(%ebp)
80104ea1:	e8 4a c1 ff ff       	call   80100ff0 <fileread>
80104ea6:	83 c4 10             	add    $0x10,%esp
}
80104ea9:	c9                   	leave  
80104eaa:	c3                   	ret    
80104eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eaf:	90                   	nop
80104eb0:	c9                   	leave  
    return -1;
80104eb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb6:	c3                   	ret    
80104eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebe:	66 90                	xchg   %ax,%ax

80104ec0 <sys_write>:
{
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec5:	31 c0                	xor    %eax,%eax
{
80104ec7:	89 e5                	mov    %esp,%ebp
80104ec9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ecc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ecf:	e8 bc fe ff ff       	call   80104d90 <argfd.constprop.0>
80104ed4:	85 c0                	test   %eax,%eax
80104ed6:	78 48                	js     80104f20 <sys_write+0x60>
80104ed8:	83 ec 08             	sub    $0x8,%esp
80104edb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ede:	50                   	push   %eax
80104edf:	6a 02                	push   $0x2
80104ee1:	e8 8a fb ff ff       	call   80104a70 <argint>
80104ee6:	83 c4 10             	add    $0x10,%esp
80104ee9:	85 c0                	test   %eax,%eax
80104eeb:	78 33                	js     80104f20 <sys_write+0x60>
80104eed:	83 ec 04             	sub    $0x4,%esp
80104ef0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ef3:	ff 75 f0             	pushl  -0x10(%ebp)
80104ef6:	50                   	push   %eax
80104ef7:	6a 01                	push   $0x1
80104ef9:	e8 c2 fb ff ff       	call   80104ac0 <argptr>
80104efe:	83 c4 10             	add    $0x10,%esp
80104f01:	85 c0                	test   %eax,%eax
80104f03:	78 1b                	js     80104f20 <sys_write+0x60>
  return filewrite(f, p, n);
80104f05:	83 ec 04             	sub    $0x4,%esp
80104f08:	ff 75 f0             	pushl  -0x10(%ebp)
80104f0b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f0e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f11:	e8 7a c1 ff ff       	call   80101090 <filewrite>
80104f16:	83 c4 10             	add    $0x10,%esp
}
80104f19:	c9                   	leave  
80104f1a:	c3                   	ret    
80104f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f1f:	90                   	nop
80104f20:	c9                   	leave  
    return -1;
80104f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f26:	c3                   	ret    
80104f27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2e:	66 90                	xchg   %ax,%ax

80104f30 <sys_close>:
{
80104f30:	f3 0f 1e fb          	endbr32 
80104f34:	55                   	push   %ebp
80104f35:	89 e5                	mov    %esp,%ebp
80104f37:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104f3a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f40:	e8 4b fe ff ff       	call   80104d90 <argfd.constprop.0>
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 27                	js     80104f70 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104f49:	e8 42 ea ff ff       	call   80103990 <myproc>
80104f4e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104f51:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f54:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104f5b:	00 
  fileclose(f);
80104f5c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f5f:	e8 5c bf ff ff       	call   80100ec0 <fileclose>
  return 0;
80104f64:	83 c4 10             	add    $0x10,%esp
80104f67:	31 c0                	xor    %eax,%eax
}
80104f69:	c9                   	leave  
80104f6a:	c3                   	ret    
80104f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f6f:	90                   	nop
80104f70:	c9                   	leave  
    return -1;
80104f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f76:	c3                   	ret    
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <sys_fstat>:
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f85:	31 c0                	xor    %eax,%eax
{
80104f87:	89 e5                	mov    %esp,%ebp
80104f89:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f8c:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f8f:	e8 fc fd ff ff       	call   80104d90 <argfd.constprop.0>
80104f94:	85 c0                	test   %eax,%eax
80104f96:	78 30                	js     80104fc8 <sys_fstat+0x48>
80104f98:	83 ec 04             	sub    $0x4,%esp
80104f9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f9e:	6a 14                	push   $0x14
80104fa0:	50                   	push   %eax
80104fa1:	6a 01                	push   $0x1
80104fa3:	e8 18 fb ff ff       	call   80104ac0 <argptr>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	85 c0                	test   %eax,%eax
80104fad:	78 19                	js     80104fc8 <sys_fstat+0x48>
  return filestat(f, st);
80104faf:	83 ec 08             	sub    $0x8,%esp
80104fb2:	ff 75 f4             	pushl  -0xc(%ebp)
80104fb5:	ff 75 f0             	pushl  -0x10(%ebp)
80104fb8:	e8 e3 bf ff ff       	call   80100fa0 <filestat>
80104fbd:	83 c4 10             	add    $0x10,%esp
}
80104fc0:	c9                   	leave  
80104fc1:	c3                   	ret    
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fc8:	c9                   	leave  
    return -1;
80104fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fce:	c3                   	ret    
80104fcf:	90                   	nop

80104fd0 <sys_link>:
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	57                   	push   %edi
80104fd8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fd9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fdc:	53                   	push   %ebx
80104fdd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fe0:	50                   	push   %eax
80104fe1:	6a 00                	push   $0x0
80104fe3:	e8 38 fb ff ff       	call   80104b20 <argstr>
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	85 c0                	test   %eax,%eax
80104fed:	0f 88 ff 00 00 00    	js     801050f2 <sys_link+0x122>
80104ff3:	83 ec 08             	sub    $0x8,%esp
80104ff6:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ff9:	50                   	push   %eax
80104ffa:	6a 01                	push   $0x1
80104ffc:	e8 1f fb ff ff       	call   80104b20 <argstr>
80105001:	83 c4 10             	add    $0x10,%esp
80105004:	85 c0                	test   %eax,%eax
80105006:	0f 88 e6 00 00 00    	js     801050f2 <sys_link+0x122>
  begin_op();
8010500c:	e8 1f dd ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80105011:	83 ec 0c             	sub    $0xc,%esp
80105014:	ff 75 d4             	pushl  -0x2c(%ebp)
80105017:	e8 14 d0 ff ff       	call   80102030 <namei>
8010501c:	83 c4 10             	add    $0x10,%esp
8010501f:	89 c3                	mov    %eax,%ebx
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 e8 00 00 00    	je     80105111 <sys_link+0x141>
  ilock(ip);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 2e c7 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010503a:	0f 84 b9 00 00 00    	je     801050f9 <sys_link+0x129>
  iupdate(ip);
80105040:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80105043:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105048:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010504b:	53                   	push   %ebx
8010504c:	e8 4f c6 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80105051:	89 1c 24             	mov    %ebx,(%esp)
80105054:	e8 e7 c7 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105059:	58                   	pop    %eax
8010505a:	5a                   	pop    %edx
8010505b:	57                   	push   %edi
8010505c:	ff 75 d0             	pushl  -0x30(%ebp)
8010505f:	e8 ec cf ff ff       	call   80102050 <nameiparent>
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	89 c6                	mov    %eax,%esi
80105069:	85 c0                	test   %eax,%eax
8010506b:	74 5f                	je     801050cc <sys_link+0xfc>
  ilock(dp);
8010506d:	83 ec 0c             	sub    $0xc,%esp
80105070:	50                   	push   %eax
80105071:	e8 ea c6 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105076:	8b 03                	mov    (%ebx),%eax
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	39 06                	cmp    %eax,(%esi)
8010507d:	75 41                	jne    801050c0 <sys_link+0xf0>
8010507f:	83 ec 04             	sub    $0x4,%esp
80105082:	ff 73 04             	pushl  0x4(%ebx)
80105085:	57                   	push   %edi
80105086:	56                   	push   %esi
80105087:	e8 e4 ce ff ff       	call   80101f70 <dirlink>
8010508c:	83 c4 10             	add    $0x10,%esp
8010508f:	85 c0                	test   %eax,%eax
80105091:	78 2d                	js     801050c0 <sys_link+0xf0>
  iunlockput(dp);
80105093:	83 ec 0c             	sub    $0xc,%esp
80105096:	56                   	push   %esi
80105097:	e8 64 c9 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
8010509c:	89 1c 24             	mov    %ebx,(%esp)
8010509f:	e8 ec c7 ff ff       	call   80101890 <iput>
  end_op();
801050a4:	e8 f7 dc ff ff       	call   80102da0 <end_op>
  return 0;
801050a9:	83 c4 10             	add    $0x10,%esp
801050ac:	31 c0                	xor    %eax,%eax
}
801050ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5f                   	pop    %edi
801050b4:	5d                   	pop    %ebp
801050b5:	c3                   	ret    
801050b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	56                   	push   %esi
801050c4:	e8 37 c9 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801050c9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	53                   	push   %ebx
801050d0:	e8 8b c6 ff ff       	call   80101760 <ilock>
  ip->nlink--;
801050d5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050da:	89 1c 24             	mov    %ebx,(%esp)
801050dd:	e8 be c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
801050e2:	89 1c 24             	mov    %ebx,(%esp)
801050e5:	e8 16 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
801050ea:	e8 b1 dc ff ff       	call   80102da0 <end_op>
  return -1;
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f7:	eb b5                	jmp    801050ae <sys_link+0xde>
    iunlockput(ip);
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	53                   	push   %ebx
801050fd:	e8 fe c8 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105102:	e8 99 dc ff ff       	call   80102da0 <end_op>
    return -1;
80105107:	83 c4 10             	add    $0x10,%esp
8010510a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510f:	eb 9d                	jmp    801050ae <sys_link+0xde>
    end_op();
80105111:	e8 8a dc ff ff       	call   80102da0 <end_op>
    return -1;
80105116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010511b:	eb 91                	jmp    801050ae <sys_link+0xde>
8010511d:	8d 76 00             	lea    0x0(%esi),%esi

80105120 <sys_unlink>:
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	57                   	push   %edi
80105128:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105129:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010512c:	53                   	push   %ebx
8010512d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105130:	50                   	push   %eax
80105131:	6a 00                	push   $0x0
80105133:	e8 e8 f9 ff ff       	call   80104b20 <argstr>
80105138:	83 c4 10             	add    $0x10,%esp
8010513b:	85 c0                	test   %eax,%eax
8010513d:	0f 88 7d 01 00 00    	js     801052c0 <sys_unlink+0x1a0>
  begin_op();
80105143:	e8 e8 db ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105148:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010514b:	83 ec 08             	sub    $0x8,%esp
8010514e:	53                   	push   %ebx
8010514f:	ff 75 c0             	pushl  -0x40(%ebp)
80105152:	e8 f9 ce ff ff       	call   80102050 <nameiparent>
80105157:	83 c4 10             	add    $0x10,%esp
8010515a:	89 c6                	mov    %eax,%esi
8010515c:	85 c0                	test   %eax,%eax
8010515e:	0f 84 66 01 00 00    	je     801052ca <sys_unlink+0x1aa>
  ilock(dp);
80105164:	83 ec 0c             	sub    $0xc,%esp
80105167:	50                   	push   %eax
80105168:	e8 f3 c5 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010516d:	58                   	pop    %eax
8010516e:	5a                   	pop    %edx
8010516f:	68 c0 7b 10 80       	push   $0x80107bc0
80105174:	53                   	push   %ebx
80105175:	e8 16 cb ff ff       	call   80101c90 <namecmp>
8010517a:	83 c4 10             	add    $0x10,%esp
8010517d:	85 c0                	test   %eax,%eax
8010517f:	0f 84 03 01 00 00    	je     80105288 <sys_unlink+0x168>
80105185:	83 ec 08             	sub    $0x8,%esp
80105188:	68 bf 7b 10 80       	push   $0x80107bbf
8010518d:	53                   	push   %ebx
8010518e:	e8 fd ca ff ff       	call   80101c90 <namecmp>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	0f 84 ea 00 00 00    	je     80105288 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010519e:	83 ec 04             	sub    $0x4,%esp
801051a1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801051a4:	50                   	push   %eax
801051a5:	53                   	push   %ebx
801051a6:	56                   	push   %esi
801051a7:	e8 04 cb ff ff       	call   80101cb0 <dirlookup>
801051ac:	83 c4 10             	add    $0x10,%esp
801051af:	89 c3                	mov    %eax,%ebx
801051b1:	85 c0                	test   %eax,%eax
801051b3:	0f 84 cf 00 00 00    	je     80105288 <sys_unlink+0x168>
  ilock(ip);
801051b9:	83 ec 0c             	sub    $0xc,%esp
801051bc:	50                   	push   %eax
801051bd:	e8 9e c5 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801051c2:	83 c4 10             	add    $0x10,%esp
801051c5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051ca:	0f 8e 23 01 00 00    	jle    801052f3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051d0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051d8:	74 66                	je     80105240 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051da:	83 ec 04             	sub    $0x4,%esp
801051dd:	6a 10                	push   $0x10
801051df:	6a 00                	push   $0x0
801051e1:	57                   	push   %edi
801051e2:	e8 a9 f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051e7:	6a 10                	push   $0x10
801051e9:	ff 75 c4             	pushl  -0x3c(%ebp)
801051ec:	57                   	push   %edi
801051ed:	56                   	push   %esi
801051ee:	e8 6d c9 ff ff       	call   80101b60 <writei>
801051f3:	83 c4 20             	add    $0x20,%esp
801051f6:	83 f8 10             	cmp    $0x10,%eax
801051f9:	0f 85 e7 00 00 00    	jne    801052e6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801051ff:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105204:	0f 84 96 00 00 00    	je     801052a0 <sys_unlink+0x180>
  iunlockput(dp);
8010520a:	83 ec 0c             	sub    $0xc,%esp
8010520d:	56                   	push   %esi
8010520e:	e8 ed c7 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105213:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105218:	89 1c 24             	mov    %ebx,(%esp)
8010521b:	e8 80 c4 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105220:	89 1c 24             	mov    %ebx,(%esp)
80105223:	e8 d8 c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105228:	e8 73 db ff ff       	call   80102da0 <end_op>
  return 0;
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	31 c0                	xor    %eax,%eax
}
80105232:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105235:	5b                   	pop    %ebx
80105236:	5e                   	pop    %esi
80105237:	5f                   	pop    %edi
80105238:	5d                   	pop    %ebp
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105240:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105244:	76 94                	jbe    801051da <sys_unlink+0xba>
80105246:	ba 20 00 00 00       	mov    $0x20,%edx
8010524b:	eb 0b                	jmp    80105258 <sys_unlink+0x138>
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
80105250:	83 c2 10             	add    $0x10,%edx
80105253:	39 53 58             	cmp    %edx,0x58(%ebx)
80105256:	76 82                	jbe    801051da <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105258:	6a 10                	push   $0x10
8010525a:	52                   	push   %edx
8010525b:	57                   	push   %edi
8010525c:	53                   	push   %ebx
8010525d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105260:	e8 fb c7 ff ff       	call   80101a60 <readi>
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010526b:	83 f8 10             	cmp    $0x10,%eax
8010526e:	75 69                	jne    801052d9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105270:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105275:	74 d9                	je     80105250 <sys_unlink+0x130>
    iunlockput(ip);
80105277:	83 ec 0c             	sub    $0xc,%esp
8010527a:	53                   	push   %ebx
8010527b:	e8 80 c7 ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105287:	90                   	nop
  iunlockput(dp);
80105288:	83 ec 0c             	sub    $0xc,%esp
8010528b:	56                   	push   %esi
8010528c:	e8 6f c7 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105291:	e8 0a db ff ff       	call   80102da0 <end_op>
  return -1;
80105296:	83 c4 10             	add    $0x10,%esp
80105299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010529e:	eb 92                	jmp    80105232 <sys_unlink+0x112>
    iupdate(dp);
801052a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801052a3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801052a8:	56                   	push   %esi
801052a9:	e8 f2 c3 ff ff       	call   801016a0 <iupdate>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	e9 54 ff ff ff       	jmp    8010520a <sys_unlink+0xea>
801052b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c5:	e9 68 ff ff ff       	jmp    80105232 <sys_unlink+0x112>
    end_op();
801052ca:	e8 d1 da ff ff       	call   80102da0 <end_op>
    return -1;
801052cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052d4:	e9 59 ff ff ff       	jmp    80105232 <sys_unlink+0x112>
      panic("isdirempty: readi");
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	68 e4 7b 10 80       	push   $0x80107be4
801052e1:	e8 aa b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801052e6:	83 ec 0c             	sub    $0xc,%esp
801052e9:	68 f6 7b 10 80       	push   $0x80107bf6
801052ee:	e8 9d b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052f3:	83 ec 0c             	sub    $0xc,%esp
801052f6:	68 d2 7b 10 80       	push   $0x80107bd2
801052fb:	e8 90 b0 ff ff       	call   80100390 <panic>

80105300 <sys_open>:

int
sys_open(void)
{
80105300:	f3 0f 1e fb          	endbr32 
80105304:	55                   	push   %ebp
80105305:	89 e5                	mov    %esp,%ebp
80105307:	57                   	push   %edi
80105308:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105309:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010530c:	53                   	push   %ebx
8010530d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105310:	50                   	push   %eax
80105311:	6a 00                	push   $0x0
80105313:	e8 08 f8 ff ff       	call   80104b20 <argstr>
80105318:	83 c4 10             	add    $0x10,%esp
8010531b:	85 c0                	test   %eax,%eax
8010531d:	0f 88 8a 00 00 00    	js     801053ad <sys_open+0xad>
80105323:	83 ec 08             	sub    $0x8,%esp
80105326:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105329:	50                   	push   %eax
8010532a:	6a 01                	push   $0x1
8010532c:	e8 3f f7 ff ff       	call   80104a70 <argint>
80105331:	83 c4 10             	add    $0x10,%esp
80105334:	85 c0                	test   %eax,%eax
80105336:	78 75                	js     801053ad <sys_open+0xad>
    return -1;

  begin_op();
80105338:	e8 f3 d9 ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
8010533d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105341:	75 75                	jne    801053b8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105343:	83 ec 0c             	sub    $0xc,%esp
80105346:	ff 75 e0             	pushl  -0x20(%ebp)
80105349:	e8 e2 cc ff ff       	call   80102030 <namei>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	89 c6                	mov    %eax,%esi
80105353:	85 c0                	test   %eax,%eax
80105355:	74 7e                	je     801053d5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105357:	83 ec 0c             	sub    $0xc,%esp
8010535a:	50                   	push   %eax
8010535b:	e8 00 c4 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105360:	83 c4 10             	add    $0x10,%esp
80105363:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105368:	0f 84 c2 00 00 00    	je     80105430 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010536e:	e8 8d ba ff ff       	call   80100e00 <filealloc>
80105373:	89 c7                	mov    %eax,%edi
80105375:	85 c0                	test   %eax,%eax
80105377:	74 23                	je     8010539c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105379:	e8 12 e6 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010537e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105380:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105384:	85 d2                	test   %edx,%edx
80105386:	74 60                	je     801053e8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	75 f0                	jne    80105380 <sys_open+0x80>
    if(f)
      fileclose(f);
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	57                   	push   %edi
80105394:	e8 27 bb ff ff       	call   80100ec0 <fileclose>
80105399:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010539c:	83 ec 0c             	sub    $0xc,%esp
8010539f:	56                   	push   %esi
801053a0:	e8 5b c6 ff ff       	call   80101a00 <iunlockput>
    end_op();
801053a5:	e8 f6 d9 ff ff       	call   80102da0 <end_op>
    return -1;
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053b2:	eb 6d                	jmp    80105421 <sys_open+0x121>
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053be:	31 c9                	xor    %ecx,%ecx
801053c0:	ba 02 00 00 00       	mov    $0x2,%edx
801053c5:	6a 00                	push   $0x0
801053c7:	e8 24 f8 ff ff       	call   80104bf0 <create>
    if(ip == 0){
801053cc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801053cf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053d1:	85 c0                	test   %eax,%eax
801053d3:	75 99                	jne    8010536e <sys_open+0x6e>
      end_op();
801053d5:	e8 c6 d9 ff ff       	call   80102da0 <end_op>
      return -1;
801053da:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801053df:	eb 40                	jmp    80105421 <sys_open+0x121>
801053e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053e8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053eb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053ef:	56                   	push   %esi
801053f0:	e8 4b c4 ff ff       	call   80101840 <iunlock>
  end_op();
801053f5:	e8 a6 d9 ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
801053fa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105403:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105406:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105409:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010540b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105412:	f7 d0                	not    %eax
80105414:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105417:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010541a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010541d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105421:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105424:	89 d8                	mov    %ebx,%eax
80105426:	5b                   	pop    %ebx
80105427:	5e                   	pop    %esi
80105428:	5f                   	pop    %edi
80105429:	5d                   	pop    %ebp
8010542a:	c3                   	ret    
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105430:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105433:	85 c9                	test   %ecx,%ecx
80105435:	0f 84 33 ff ff ff    	je     8010536e <sys_open+0x6e>
8010543b:	e9 5c ff ff ff       	jmp    8010539c <sys_open+0x9c>

80105440 <sys_mkdir>:

int
sys_mkdir(void)
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010544a:	e8 e1 d8 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105455:	50                   	push   %eax
80105456:	6a 00                	push   $0x0
80105458:	e8 c3 f6 ff ff       	call   80104b20 <argstr>
8010545d:	83 c4 10             	add    $0x10,%esp
80105460:	85 c0                	test   %eax,%eax
80105462:	78 34                	js     80105498 <sys_mkdir+0x58>
80105464:	83 ec 0c             	sub    $0xc,%esp
80105467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010546a:	31 c9                	xor    %ecx,%ecx
8010546c:	ba 01 00 00 00       	mov    $0x1,%edx
80105471:	6a 00                	push   $0x0
80105473:	e8 78 f7 ff ff       	call   80104bf0 <create>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	74 19                	je     80105498 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010547f:	83 ec 0c             	sub    $0xc,%esp
80105482:	50                   	push   %eax
80105483:	e8 78 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105488:	e8 13 d9 ff ff       	call   80102da0 <end_op>
  return 0;
8010548d:	83 c4 10             	add    $0x10,%esp
80105490:	31 c0                	xor    %eax,%eax
}
80105492:	c9                   	leave  
80105493:	c3                   	ret    
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105498:	e8 03 d9 ff ff       	call   80102da0 <end_op>
    return -1;
8010549d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a2:	c9                   	leave  
801054a3:	c3                   	ret    
801054a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054af:	90                   	nop

801054b0 <sys_mknod>:

int
sys_mknod(void)
{
801054b0:	f3 0f 1e fb          	endbr32 
801054b4:	55                   	push   %ebp
801054b5:	89 e5                	mov    %esp,%ebp
801054b7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801054ba:	e8 71 d8 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801054bf:	83 ec 08             	sub    $0x8,%esp
801054c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801054c5:	50                   	push   %eax
801054c6:	6a 00                	push   $0x0
801054c8:	e8 53 f6 ff ff       	call   80104b20 <argstr>
801054cd:	83 c4 10             	add    $0x10,%esp
801054d0:	85 c0                	test   %eax,%eax
801054d2:	78 64                	js     80105538 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801054d4:	83 ec 08             	sub    $0x8,%esp
801054d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054da:	50                   	push   %eax
801054db:	6a 01                	push   $0x1
801054dd:	e8 8e f5 ff ff       	call   80104a70 <argint>
  if((argstr(0, &path)) < 0 ||
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	85 c0                	test   %eax,%eax
801054e7:	78 4f                	js     80105538 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
801054e9:	83 ec 08             	sub    $0x8,%esp
801054ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ef:	50                   	push   %eax
801054f0:	6a 02                	push   $0x2
801054f2:	e8 79 f5 ff ff       	call   80104a70 <argint>
     argint(1, &major) < 0 ||
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	78 3a                	js     80105538 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054fe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105502:	83 ec 0c             	sub    $0xc,%esp
80105505:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105509:	ba 03 00 00 00       	mov    $0x3,%edx
8010550e:	50                   	push   %eax
8010550f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105512:	e8 d9 f6 ff ff       	call   80104bf0 <create>
     argint(2, &minor) < 0 ||
80105517:	83 c4 10             	add    $0x10,%esp
8010551a:	85 c0                	test   %eax,%eax
8010551c:	74 1a                	je     80105538 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010551e:	83 ec 0c             	sub    $0xc,%esp
80105521:	50                   	push   %eax
80105522:	e8 d9 c4 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105527:	e8 74 d8 ff ff       	call   80102da0 <end_op>
  return 0;
8010552c:	83 c4 10             	add    $0x10,%esp
8010552f:	31 c0                	xor    %eax,%eax
}
80105531:	c9                   	leave  
80105532:	c3                   	ret    
80105533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105537:	90                   	nop
    end_op();
80105538:	e8 63 d8 ff ff       	call   80102da0 <end_op>
    return -1;
8010553d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105542:	c9                   	leave  
80105543:	c3                   	ret    
80105544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <sys_chdir>:

int
sys_chdir(void)
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	56                   	push   %esi
80105558:	53                   	push   %ebx
80105559:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010555c:	e8 2f e4 ff ff       	call   80103990 <myproc>
80105561:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105563:	e8 c8 d7 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 00                	push   $0x0
80105571:	e8 aa f5 ff ff       	call   80104b20 <argstr>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 73                	js     801055f0 <sys_chdir+0xa0>
8010557d:	83 ec 0c             	sub    $0xc,%esp
80105580:	ff 75 f4             	pushl  -0xc(%ebp)
80105583:	e8 a8 ca ff ff       	call   80102030 <namei>
80105588:	83 c4 10             	add    $0x10,%esp
8010558b:	89 c3                	mov    %eax,%ebx
8010558d:	85 c0                	test   %eax,%eax
8010558f:	74 5f                	je     801055f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105591:	83 ec 0c             	sub    $0xc,%esp
80105594:	50                   	push   %eax
80105595:	e8 c6 c1 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055a2:	75 2c                	jne    801055d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055a4:	83 ec 0c             	sub    $0xc,%esp
801055a7:	53                   	push   %ebx
801055a8:	e8 93 c2 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801055ad:	58                   	pop    %eax
801055ae:	ff 76 68             	pushl  0x68(%esi)
801055b1:	e8 da c2 ff ff       	call   80101890 <iput>
  end_op();
801055b6:	e8 e5 d7 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
801055bb:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	31 c0                	xor    %eax,%eax
}
801055c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055c6:	5b                   	pop    %ebx
801055c7:	5e                   	pop    %esi
801055c8:	5d                   	pop    %ebp
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	53                   	push   %ebx
801055d4:	e8 27 c4 ff ff       	call   80101a00 <iunlockput>
    end_op();
801055d9:	e8 c2 d7 ff ff       	call   80102da0 <end_op>
    return -1;
801055de:	83 c4 10             	add    $0x10,%esp
801055e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e6:	eb db                	jmp    801055c3 <sys_chdir+0x73>
801055e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
    end_op();
801055f0:	e8 ab d7 ff ff       	call   80102da0 <end_op>
    return -1;
801055f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055fa:	eb c7                	jmp    801055c3 <sys_chdir+0x73>
801055fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105600 <sys_exec>:

int
sys_exec(void)
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
80105605:	89 e5                	mov    %esp,%ebp
80105607:	57                   	push   %edi
80105608:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105609:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010560f:	53                   	push   %ebx
80105610:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105616:	50                   	push   %eax
80105617:	6a 00                	push   $0x0
80105619:	e8 02 f5 ff ff       	call   80104b20 <argstr>
8010561e:	83 c4 10             	add    $0x10,%esp
80105621:	85 c0                	test   %eax,%eax
80105623:	0f 88 8b 00 00 00    	js     801056b4 <sys_exec+0xb4>
80105629:	83 ec 08             	sub    $0x8,%esp
8010562c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105632:	50                   	push   %eax
80105633:	6a 01                	push   $0x1
80105635:	e8 36 f4 ff ff       	call   80104a70 <argint>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	78 73                	js     801056b4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105641:	83 ec 04             	sub    $0x4,%esp
80105644:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010564a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010564c:	68 80 00 00 00       	push   $0x80
80105651:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105657:	6a 00                	push   $0x0
80105659:	50                   	push   %eax
8010565a:	e8 31 f1 ff ff       	call   80104790 <memset>
8010565f:	83 c4 10             	add    $0x10,%esp
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105668:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010566e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	57                   	push   %edi
80105679:	01 f0                	add    %esi,%eax
8010567b:	50                   	push   %eax
8010567c:	e8 4f f3 ff ff       	call   801049d0 <fetchint>
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	85 c0                	test   %eax,%eax
80105686:	78 2c                	js     801056b4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105688:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010568e:	85 c0                	test   %eax,%eax
80105690:	74 36                	je     801056c8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105692:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105698:	83 ec 08             	sub    $0x8,%esp
8010569b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010569e:	52                   	push   %edx
8010569f:	50                   	push   %eax
801056a0:	e8 6b f3 ff ff       	call   80104a10 <fetchstr>
801056a5:	83 c4 10             	add    $0x10,%esp
801056a8:	85 c0                	test   %eax,%eax
801056aa:	78 08                	js     801056b4 <sys_exec+0xb4>
  for(i=0;; i++){
801056ac:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801056af:	83 fb 20             	cmp    $0x20,%ebx
801056b2:	75 b4                	jne    80105668 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801056b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801056b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056bc:	5b                   	pop    %ebx
801056bd:	5e                   	pop    %esi
801056be:	5f                   	pop    %edi
801056bf:	5d                   	pop    %ebp
801056c0:	c3                   	ret    
801056c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801056c8:	83 ec 08             	sub    $0x8,%esp
801056cb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801056d1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801056d8:	00 00 00 00 
  return exec(path, argv);
801056dc:	50                   	push   %eax
801056dd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801056e3:	e8 98 b3 ff ff       	call   80100a80 <exec>
801056e8:	83 c4 10             	add    $0x10,%esp
}
801056eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ee:	5b                   	pop    %ebx
801056ef:	5e                   	pop    %esi
801056f0:	5f                   	pop    %edi
801056f1:	5d                   	pop    %ebp
801056f2:	c3                   	ret    
801056f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105700 <sys_pipe>:

int
sys_pipe(void)
{
80105700:	f3 0f 1e fb          	endbr32 
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	57                   	push   %edi
80105708:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105709:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010570c:	53                   	push   %ebx
8010570d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105710:	6a 08                	push   $0x8
80105712:	50                   	push   %eax
80105713:	6a 00                	push   $0x0
80105715:	e8 a6 f3 ff ff       	call   80104ac0 <argptr>
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	85 c0                	test   %eax,%eax
8010571f:	78 4e                	js     8010576f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105721:	83 ec 08             	sub    $0x8,%esp
80105724:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105727:	50                   	push   %eax
80105728:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010572b:	50                   	push   %eax
8010572c:	e8 bf dc ff ff       	call   801033f0 <pipealloc>
80105731:	83 c4 10             	add    $0x10,%esp
80105734:	85 c0                	test   %eax,%eax
80105736:	78 37                	js     8010576f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105738:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010573b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010573d:	e8 4e e2 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105748:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010574c:	85 f6                	test   %esi,%esi
8010574e:	74 30                	je     80105780 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105750:	83 c3 01             	add    $0x1,%ebx
80105753:	83 fb 10             	cmp    $0x10,%ebx
80105756:	75 f0                	jne    80105748 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105758:	83 ec 0c             	sub    $0xc,%esp
8010575b:	ff 75 e0             	pushl  -0x20(%ebp)
8010575e:	e8 5d b7 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105763:	58                   	pop    %eax
80105764:	ff 75 e4             	pushl  -0x1c(%ebp)
80105767:	e8 54 b7 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010576c:	83 c4 10             	add    $0x10,%esp
8010576f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105774:	eb 5b                	jmp    801057d1 <sys_pipe+0xd1>
80105776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105780:	8d 73 08             	lea    0x8(%ebx),%esi
80105783:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105787:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010578a:	e8 01 e2 ff ff       	call   80103990 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010578f:	31 d2                	xor    %edx,%edx
80105791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105798:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010579c:	85 c9                	test   %ecx,%ecx
8010579e:	74 20                	je     801057c0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801057a0:	83 c2 01             	add    $0x1,%edx
801057a3:	83 fa 10             	cmp    $0x10,%edx
801057a6:	75 f0                	jne    80105798 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801057a8:	e8 e3 e1 ff ff       	call   80103990 <myproc>
801057ad:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801057b4:	00 
801057b5:	eb a1                	jmp    80105758 <sys_pipe+0x58>
801057b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801057c0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801057c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057c7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801057c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801057cc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801057cf:	31 c0                	xor    %eax,%eax
}
801057d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d4:	5b                   	pop    %ebx
801057d5:	5e                   	pop    %esi
801057d6:	5f                   	pop    %edi
801057d7:	5d                   	pop    %ebp
801057d8:	c3                   	ret    
801057d9:	66 90                	xchg   %ax,%ax
801057db:	66 90                	xchg   %ax,%ax
801057dd:	66 90                	xchg   %ax,%ax
801057df:	90                   	nop

801057e0 <sys_fork>:

extern int readcount_global;

int
sys_fork(void)
{
801057e0:	f3 0f 1e fb          	endbr32 
  return fork();
801057e4:	e9 67 e3 ff ff       	jmp    80103b50 <fork>
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_exit>:
}

int
sys_exit(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	83 ec 08             	sub    $0x8,%esp
  exit();
801057fa:	e8 91 e6 ff ff       	call   80103e90 <exit>
  return 0;  // not reached
}
801057ff:	31 c0                	xor    %eax,%eax
80105801:	c9                   	leave  
80105802:	c3                   	ret    
80105803:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010580a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105810 <sys_wait>:

int
sys_wait(void)
{
80105810:	f3 0f 1e fb          	endbr32 
  return wait();
80105814:	e9 c7 e8 ff ff       	jmp    801040e0 <wait>
80105819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_kill>:
}

int
sys_kill(void)
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
80105825:	89 e5                	mov    %esp,%ebp
80105827:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010582a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010582d:	50                   	push   %eax
8010582e:	6a 00                	push   $0x0
80105830:	e8 3b f2 ff ff       	call   80104a70 <argint>
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	85 c0                	test   %eax,%eax
8010583a:	78 14                	js     80105850 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	ff 75 f4             	pushl  -0xc(%ebp)
80105842:	e8 09 ea ff ff       	call   80104250 <kill>
80105847:	83 c4 10             	add    $0x10,%esp
}
8010584a:	c9                   	leave  
8010584b:	c3                   	ret    
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105850:	c9                   	leave  
    return -1;
80105851:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105856:	c3                   	ret    
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax

80105860 <sys_getpid>:

int
sys_getpid(void)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010586a:	e8 21 e1 ff ff       	call   80103990 <myproc>
8010586f:	8b 40 10             	mov    0x10(%eax),%eax
}
80105872:	c9                   	leave  
80105873:	c3                   	ret    
80105874:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010587b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop

80105880 <sys_sbrk>:

int
sys_sbrk(void)
{
80105880:	f3 0f 1e fb          	endbr32 
80105884:	55                   	push   %ebp
80105885:	89 e5                	mov    %esp,%ebp
80105887:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105888:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010588b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010588e:	50                   	push   %eax
8010588f:	6a 00                	push   $0x0
80105891:	e8 da f1 ff ff       	call   80104a70 <argint>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	78 23                	js     801058c0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010589d:	e8 ee e0 ff ff       	call   80103990 <myproc>
  if(growproc(n) < 0)
801058a2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058a5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058a7:	ff 75 f4             	pushl  -0xc(%ebp)
801058aa:	e8 21 e2 ff ff       	call   80103ad0 <growproc>
801058af:	83 c4 10             	add    $0x10,%esp
801058b2:	85 c0                	test   %eax,%eax
801058b4:	78 0a                	js     801058c0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058b6:	89 d8                	mov    %ebx,%eax
801058b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058bb:	c9                   	leave  
801058bc:	c3                   	ret    
801058bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058c0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058c5:	eb ef                	jmp    801058b6 <sys_sbrk+0x36>
801058c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058ce:	66 90                	xchg   %ax,%ax

801058d0 <sys_sleep>:

int
sys_sleep(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801058d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058db:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058de:	50                   	push   %eax
801058df:	6a 00                	push   $0x0
801058e1:	e8 8a f1 ff ff       	call   80104a70 <argint>
801058e6:	83 c4 10             	add    $0x10,%esp
801058e9:	85 c0                	test   %eax,%eax
801058eb:	0f 88 86 00 00 00    	js     80105977 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801058f1:	83 ec 0c             	sub    $0xc,%esp
801058f4:	68 60 50 11 80       	push   $0x80115060
801058f9:	e8 82 ed ff ff       	call   80104680 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801058fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105901:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	85 d2                	test   %edx,%edx
8010590c:	75 23                	jne    80105931 <sys_sleep+0x61>
8010590e:	eb 50                	jmp    80105960 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	68 60 50 11 80       	push   $0x80115060
80105918:	68 a0 58 11 80       	push   $0x801158a0
8010591d:	e8 fe e6 ff ff       	call   80104020 <sleep>
  while(ticks - ticks0 < n){
80105922:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80105927:	83 c4 10             	add    $0x10,%esp
8010592a:	29 d8                	sub    %ebx,%eax
8010592c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010592f:	73 2f                	jae    80105960 <sys_sleep+0x90>
    if(myproc()->killed){
80105931:	e8 5a e0 ff ff       	call   80103990 <myproc>
80105936:	8b 40 24             	mov    0x24(%eax),%eax
80105939:	85 c0                	test   %eax,%eax
8010593b:	74 d3                	je     80105910 <sys_sleep+0x40>
      release(&tickslock);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	68 60 50 11 80       	push   $0x80115060
80105945:	e8 f6 ed ff ff       	call   80104740 <release>
  }
  release(&tickslock);
  return 0;
}
8010594a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	68 60 50 11 80       	push   $0x80115060
80105968:	e8 d3 ed ff ff       	call   80104740 <release>
  return 0;
8010596d:	83 c4 10             	add    $0x10,%esp
80105970:	31 c0                	xor    %eax,%eax
}
80105972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105975:	c9                   	leave  
80105976:	c3                   	ret    
    return -1;
80105977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010597c:	eb f4                	jmp    80105972 <sys_sleep+0xa2>
8010597e:	66 90                	xchg   %ax,%ax

80105980 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105980:	f3 0f 1e fb          	endbr32 
80105984:	55                   	push   %ebp
80105985:	89 e5                	mov    %esp,%ebp
80105987:	53                   	push   %ebx
80105988:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010598b:	68 60 50 11 80       	push   $0x80115060
80105990:	e8 eb ec ff ff       	call   80104680 <acquire>
  xticks = ticks;
80105995:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
8010599b:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801059a2:	e8 99 ed ff ff       	call   80104740 <release>
  return xticks;
}
801059a7:	89 d8                	mov    %ebx,%eax
801059a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ac:	c9                   	leave  
801059ad:	c3                   	ret    
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <sys_getreadcount>:


int 
sys_getreadcount(void)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	83 ec 20             	sub    $0x20,%esp
  int n;
  if(argint(0, &n) < 0)
801059ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059bd:	50                   	push   %eax
801059be:	6a 00                	push   $0x0
801059c0:	e8 ab f0 ff ff       	call   80104a70 <argint>
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	85 c0                	test   %eax,%eax
801059ca:	78 1e                	js     801059ea <sys_getreadcount+0x3a>
    return -1;
  if(n == 0)
801059cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
    return myproc()->readcount;
  else
    return readcount_global;  
801059cf:	a1 f8 c8 10 80       	mov    0x8010c8f8,%eax
  if(n == 0)
801059d4:	85 d2                	test   %edx,%edx
801059d6:	74 08                	je     801059e0 <sys_getreadcount+0x30>
}
801059d8:	c9                   	leave  
801059d9:	c3                   	ret    
801059da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return myproc()->readcount;
801059e0:	e8 ab df ff ff       	call   80103990 <myproc>
801059e5:	8b 40 7c             	mov    0x7c(%eax),%eax
}
801059e8:	c9                   	leave  
801059e9:	c3                   	ret    
801059ea:	c9                   	leave  
    return -1;
801059eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f0:	c3                   	ret    
801059f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop

80105a00 <sys_settickets>:

int
sys_settickets(void)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	53                   	push   %ebx
  int n;
  if(argint(0, &n) < 0)
80105a08:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a0b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a0e:	50                   	push   %eax
80105a0f:	6a 00                	push   $0x0
80105a11:	e8 5a f0 ff ff       	call   80104a70 <argint>
80105a16:	83 c4 10             	add    $0x10,%esp
80105a19:	85 c0                	test   %eax,%eax
80105a1b:	78 43                	js     80105a60 <sys_settickets+0x60>
    return -1;
  if(n < 1)
80105a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a20:	85 c0                	test   %eax,%eax
80105a22:	7e 3c                	jle    80105a60 <sys_settickets+0x60>
    return -1;
  struct proc *curproc = myproc();
80105a24:	e8 67 df ff ff       	call   80103990 <myproc>
 // cprintf("tickets before settickets: %d\n", curproc->tickets);
  acquire(&ptable.lock); 
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	68 c0 a5 10 80       	push   $0x8010a5c0
  struct proc *curproc = myproc();
80105a31:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock); 
80105a33:	e8 48 ec ff ff       	call   80104680 <acquire>
  curproc->tickets = n;
80105a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  release(&ptable.lock);
80105a41:	c7 04 24 c0 a5 10 80 	movl   $0x8010a5c0,(%esp)
80105a48:	e8 f3 ec ff ff       	call   80104740 <release>
  //acquiring the lock is important here because getpinfo can access this while settickets is modifying tickets.
 //scheduler acquires lock before totalling tickets for that round of scheduling. so settickets cannot interfere with that by changing tickets between te=he round.
 // cprintf("tickets after settickets: %d\n", curproc->tickets);
  return 0;  
80105a4d:	83 c4 10             	add    $0x10,%esp
80105a50:	31 c0                	xor    %eax,%eax
}
80105a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a55:	c9                   	leave  
80105a56:	c3                   	ret    
80105a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a5e:	66 90                	xchg   %ax,%ax
    return -1;
80105a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a65:	eb eb                	jmp    80105a52 <sys_settickets+0x52>
80105a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <sys_getpinfo>:

int
sys_getpinfo(void)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	53                   	push   %ebx
  struct pstat *procstat;
  struct proc *proc;

  if(argint(0, (int *)&procstat) < 0)//change this to argptr.
80105a78:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a7b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, (int *)&procstat) < 0)//change this to argptr.
80105a7e:	50                   	push   %eax
80105a7f:	6a 00                	push   $0x0
80105a81:	e8 ea ef ff ff       	call   80104a70 <argint>
80105a86:	83 c4 10             	add    $0x10,%esp
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	0f 88 8d 00 00 00    	js     80105b1e <sys_getpinfo+0xae>
    return -1;
  

  acquire(&ptable.lock);
80105a91:	83 ec 0c             	sub    $0xc,%esp
80105a94:	68 c0 a5 10 80       	push   $0x8010a5c0
80105a99:	e8 e2 eb ff ff       	call   80104680 <acquire>
80105a9e:	83 c4 10             	add    $0x10,%esp
  for(proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80105aa1:	b8 f4 a5 10 80       	mov    $0x8010a5f4,%eax
80105aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aad:	8d 76 00             	lea    0x0(%esi),%esi
    int index = proc - ptable.proc;
    if(proc->state != UNUSED){
80105ab0:	8b 50 0c             	mov    0xc(%eax),%edx
80105ab3:	85 d2                	test   %edx,%edx
80105ab5:	74 44                	je     80105afb <sys_getpinfo+0x8b>
    int index = proc - ptable.proc;
80105ab7:	89 c2                	mov    %eax,%edx
      procstat->inuse[index] = proc->inuse;
80105ab9:	8b 98 88 00 00 00    	mov    0x88(%eax),%ebx
80105abf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    int index = proc - ptable.proc;
80105ac2:	81 ea f4 a5 10 80    	sub    $0x8010a5f4,%edx
80105ac8:	c1 fa 02             	sar    $0x2,%edx
80105acb:	69 d2 8b af f8 8a    	imul   $0x8af8af8b,%edx,%edx
      procstat->inuse[index] = proc->inuse;
80105ad1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
      procstat->tickets[index] = proc->tickets;
80105ad4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80105ad7:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80105add:	8d 14 93             	lea    (%ebx,%edx,4),%edx
80105ae0:	89 8a 00 01 00 00    	mov    %ecx,0x100(%edx)
      procstat->pid[index] = proc->pid;
80105ae6:	8b 48 10             	mov    0x10(%eax),%ecx
80105ae9:	89 8a 00 02 00 00    	mov    %ecx,0x200(%edx)
      procstat->ticks[index] = proc->ticks; 
80105aef:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105af5:	89 8a 00 03 00 00    	mov    %ecx,0x300(%edx)
  for(proc = ptable.proc; proc < &ptable.proc[NPROC]; proc++){
80105afb:	05 8c 00 00 00       	add    $0x8c,%eax
80105b00:	3d f4 c8 10 80       	cmp    $0x8010c8f4,%eax
80105b05:	75 a9                	jne    80105ab0 <sys_getpinfo+0x40>
    }
    }
  release(&ptable.lock);
80105b07:	83 ec 0c             	sub    $0xc,%esp
80105b0a:	68 c0 a5 10 80       	push   $0x8010a5c0
80105b0f:	e8 2c ec ff ff       	call   80104740 <release>
  return 0;
80105b14:	83 c4 10             	add    $0x10,%esp
80105b17:	31 c0                	xor    %eax,%eax
}
80105b19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b1c:	c9                   	leave  
80105b1d:	c3                   	ret    
    return -1;
80105b1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b23:	eb f4                	jmp    80105b19 <sys_getpinfo+0xa9>

80105b25 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b25:	1e                   	push   %ds
  pushl %es
80105b26:	06                   	push   %es
  pushl %fs
80105b27:	0f a0                	push   %fs
  pushl %gs
80105b29:	0f a8                	push   %gs
  pushal
80105b2b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b2c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b30:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b32:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b34:	54                   	push   %esp
  call trap
80105b35:	e8 c6 00 00 00       	call   80105c00 <trap>
  addl $4, %esp
80105b3a:	83 c4 04             	add    $0x4,%esp

80105b3d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b3d:	61                   	popa   
  popl %gs
80105b3e:	0f a9                	pop    %gs
  popl %fs
80105b40:	0f a1                	pop    %fs
  popl %es
80105b42:	07                   	pop    %es
  popl %ds
80105b43:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b44:	83 c4 08             	add    $0x8,%esp
  iret
80105b47:	cf                   	iret   
80105b48:	66 90                	xchg   %ax,%ax
80105b4a:	66 90                	xchg   %ax,%ax
80105b4c:	66 90                	xchg   %ax,%ax
80105b4e:	66 90                	xchg   %ax,%ax

80105b50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b55:	31 c0                	xor    %eax,%eax
{
80105b57:	89 e5                	mov    %esp,%ebp
80105b59:	83 ec 08             	sub    $0x8,%esp
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b60:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b67:	c7 04 c5 a2 50 11 80 	movl   $0x8e000008,-0x7feeaf5e(,%eax,8)
80105b6e:	08 00 00 8e 
80105b72:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80105b79:	80 
80105b7a:	c1 ea 10             	shr    $0x10,%edx
80105b7d:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
80105b84:	80 
  for(i = 0; i < 256; i++)
80105b85:	83 c0 01             	add    $0x1,%eax
80105b88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b8d:	75 d1                	jne    80105b60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105b8f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b92:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105b97:	c7 05 a2 52 11 80 08 	movl   $0xef000008,0x801152a2
80105b9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ba1:	68 05 7c 10 80       	push   $0x80107c05
80105ba6:	68 60 50 11 80       	push   $0x80115060
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105bab:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105bb1:	c1 e8 10             	shr    $0x10,%eax
80105bb4:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
  initlock(&tickslock, "time");
80105bba:	e8 41 e9 ff ff       	call   80104500 <initlock>
}
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	c9                   	leave  
80105bc3:	c3                   	ret    
80105bc4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bcf:	90                   	nop

80105bd0 <idtinit>:

void
idtinit(void)
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
  pd[0] = size-1;
80105bd5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bda:	89 e5                	mov    %esp,%ebp
80105bdc:	83 ec 10             	sub    $0x10,%esp
80105bdf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105be3:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
80105be8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bec:	c1 e8 10             	shr    $0x10,%eax
80105bef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bf3:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bf6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bf9:	c9                   	leave  
80105bfa:	c3                   	ret    
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop

80105c00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105c00:	f3 0f 1e fb          	endbr32 
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	57                   	push   %edi
80105c08:	56                   	push   %esi
80105c09:	53                   	push   %ebx
80105c0a:	83 ec 1c             	sub    $0x1c,%esp
80105c0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105c10:	8b 43 30             	mov    0x30(%ebx),%eax
80105c13:	83 f8 40             	cmp    $0x40,%eax
80105c16:	0f 84 bc 01 00 00    	je     80105dd8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105c1c:	83 e8 20             	sub    $0x20,%eax
80105c1f:	83 f8 1f             	cmp    $0x1f,%eax
80105c22:	77 08                	ja     80105c2c <trap+0x2c>
80105c24:	3e ff 24 85 ac 7c 10 	notrack jmp *-0x7fef8354(,%eax,4)
80105c2b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c2c:	e8 5f dd ff ff       	call   80103990 <myproc>
80105c31:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c34:	85 c0                	test   %eax,%eax
80105c36:	0f 84 eb 01 00 00    	je     80105e27 <trap+0x227>
80105c3c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105c40:	0f 84 e1 01 00 00    	je     80105e27 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c46:	0f 20 d1             	mov    %cr2,%ecx
80105c49:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c4c:	e8 1f dd ff ff       	call   80103970 <cpuid>
80105c51:	8b 73 30             	mov    0x30(%ebx),%esi
80105c54:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c57:	8b 43 34             	mov    0x34(%ebx),%eax
80105c5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c5d:	e8 2e dd ff ff       	call   80103990 <myproc>
80105c62:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c65:	e8 26 dd ff ff       	call   80103990 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c6a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c70:	51                   	push   %ecx
80105c71:	57                   	push   %edi
80105c72:	52                   	push   %edx
80105c73:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c76:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c77:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105c7a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c7d:	56                   	push   %esi
80105c7e:	ff 70 10             	pushl  0x10(%eax)
80105c81:	68 68 7c 10 80       	push   $0x80107c68
80105c86:	e8 25 aa ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c8b:	83 c4 20             	add    $0x20,%esp
80105c8e:	e8 fd dc ff ff       	call   80103990 <myproc>
80105c93:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 f1 dc ff ff       	call   80103990 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	74 1d                	je     80105cc0 <trap+0xc0>
80105ca3:	e8 e8 dc ff ff       	call   80103990 <myproc>
80105ca8:	8b 50 24             	mov    0x24(%eax),%edx
80105cab:	85 d2                	test   %edx,%edx
80105cad:	74 11                	je     80105cc0 <trap+0xc0>
80105caf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cb3:	83 e0 03             	and    $0x3,%eax
80105cb6:	66 83 f8 03          	cmp    $0x3,%ax
80105cba:	0f 84 50 01 00 00    	je     80105e10 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105cc0:	e8 cb dc ff ff       	call   80103990 <myproc>
80105cc5:	85 c0                	test   %eax,%eax
80105cc7:	74 0f                	je     80105cd8 <trap+0xd8>
80105cc9:	e8 c2 dc ff ff       	call   80103990 <myproc>
80105cce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cd2:	0f 84 e8 00 00 00    	je     80105dc0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cd8:	e8 b3 dc ff ff       	call   80103990 <myproc>
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	74 1d                	je     80105cfe <trap+0xfe>
80105ce1:	e8 aa dc ff ff       	call   80103990 <myproc>
80105ce6:	8b 40 24             	mov    0x24(%eax),%eax
80105ce9:	85 c0                	test   %eax,%eax
80105ceb:	74 11                	je     80105cfe <trap+0xfe>
80105ced:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105cf1:	83 e0 03             	and    $0x3,%eax
80105cf4:	66 83 f8 03          	cmp    $0x3,%ax
80105cf8:	0f 84 03 01 00 00    	je     80105e01 <trap+0x201>
    exit();
}
80105cfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d01:	5b                   	pop    %ebx
80105d02:	5e                   	pop    %esi
80105d03:	5f                   	pop    %edi
80105d04:	5d                   	pop    %ebp
80105d05:	c3                   	ret    
    ideintr();
80105d06:	e8 d5 c4 ff ff       	call   801021e0 <ideintr>
    lapiceoi();
80105d0b:	e8 b0 cb ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d10:	e8 7b dc ff ff       	call   80103990 <myproc>
80105d15:	85 c0                	test   %eax,%eax
80105d17:	75 8a                	jne    80105ca3 <trap+0xa3>
80105d19:	eb a5                	jmp    80105cc0 <trap+0xc0>
    if(cpuid() == 0){
80105d1b:	e8 50 dc ff ff       	call   80103970 <cpuid>
80105d20:	85 c0                	test   %eax,%eax
80105d22:	75 e7                	jne    80105d0b <trap+0x10b>
      acquire(&tickslock);
80105d24:	83 ec 0c             	sub    $0xc,%esp
80105d27:	68 60 50 11 80       	push   $0x80115060
80105d2c:	e8 4f e9 ff ff       	call   80104680 <acquire>
      wakeup(&ticks);
80105d31:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
      ticks++;
80105d38:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
80105d3f:	e8 9c e4 ff ff       	call   801041e0 <wakeup>
      release(&tickslock);
80105d44:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105d4b:	e8 f0 e9 ff ff       	call   80104740 <release>
80105d50:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d53:	eb b6                	jmp    80105d0b <trap+0x10b>
    kbdintr();
80105d55:	e8 26 ca ff ff       	call   80102780 <kbdintr>
    lapiceoi();
80105d5a:	e8 61 cb ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d5f:	e8 2c dc ff ff       	call   80103990 <myproc>
80105d64:	85 c0                	test   %eax,%eax
80105d66:	0f 85 37 ff ff ff    	jne    80105ca3 <trap+0xa3>
80105d6c:	e9 4f ff ff ff       	jmp    80105cc0 <trap+0xc0>
    uartintr();
80105d71:	e8 4a 02 00 00       	call   80105fc0 <uartintr>
    lapiceoi();
80105d76:	e8 45 cb ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d7b:	e8 10 dc ff ff       	call   80103990 <myproc>
80105d80:	85 c0                	test   %eax,%eax
80105d82:	0f 85 1b ff ff ff    	jne    80105ca3 <trap+0xa3>
80105d88:	e9 33 ff ff ff       	jmp    80105cc0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d8d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105d90:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105d94:	e8 d7 db ff ff       	call   80103970 <cpuid>
80105d99:	57                   	push   %edi
80105d9a:	56                   	push   %esi
80105d9b:	50                   	push   %eax
80105d9c:	68 10 7c 10 80       	push   $0x80107c10
80105da1:	e8 0a a9 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105da6:	e8 15 cb ff ff       	call   801028c0 <lapiceoi>
    break;
80105dab:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dae:	e8 dd db ff ff       	call   80103990 <myproc>
80105db3:	85 c0                	test   %eax,%eax
80105db5:	0f 85 e8 fe ff ff    	jne    80105ca3 <trap+0xa3>
80105dbb:	e9 00 ff ff ff       	jmp    80105cc0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105dc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105dc4:	0f 85 0e ff ff ff    	jne    80105cd8 <trap+0xd8>
    yield();
80105dca:	e8 01 e2 ff ff       	call   80103fd0 <yield>
80105dcf:	e9 04 ff ff ff       	jmp    80105cd8 <trap+0xd8>
80105dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105dd8:	e8 b3 db ff ff       	call   80103990 <myproc>
80105ddd:	8b 70 24             	mov    0x24(%eax),%esi
80105de0:	85 f6                	test   %esi,%esi
80105de2:	75 3c                	jne    80105e20 <trap+0x220>
    myproc()->tf = tf;
80105de4:	e8 a7 db ff ff       	call   80103990 <myproc>
80105de9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105dec:	e8 6f ed ff ff       	call   80104b60 <syscall>
    if(myproc()->killed)
80105df1:	e8 9a db ff ff       	call   80103990 <myproc>
80105df6:	8b 48 24             	mov    0x24(%eax),%ecx
80105df9:	85 c9                	test   %ecx,%ecx
80105dfb:	0f 84 fd fe ff ff    	je     80105cfe <trap+0xfe>
}
80105e01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e04:	5b                   	pop    %ebx
80105e05:	5e                   	pop    %esi
80105e06:	5f                   	pop    %edi
80105e07:	5d                   	pop    %ebp
      exit();
80105e08:	e9 83 e0 ff ff       	jmp    80103e90 <exit>
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105e10:	e8 7b e0 ff ff       	call   80103e90 <exit>
80105e15:	e9 a6 fe ff ff       	jmp    80105cc0 <trap+0xc0>
80105e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105e20:	e8 6b e0 ff ff       	call   80103e90 <exit>
80105e25:	eb bd                	jmp    80105de4 <trap+0x1e4>
80105e27:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e2a:	e8 41 db ff ff       	call   80103970 <cpuid>
80105e2f:	83 ec 0c             	sub    $0xc,%esp
80105e32:	56                   	push   %esi
80105e33:	57                   	push   %edi
80105e34:	50                   	push   %eax
80105e35:	ff 73 30             	pushl  0x30(%ebx)
80105e38:	68 34 7c 10 80       	push   $0x80107c34
80105e3d:	e8 6e a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105e42:	83 c4 14             	add    $0x14,%esp
80105e45:	68 0a 7c 10 80       	push   $0x80107c0a
80105e4a:	e8 41 a5 ff ff       	call   80100390 <panic>
80105e4f:	90                   	nop

80105e50 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105e50:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105e54:	a1 fc c8 10 80       	mov    0x8010c8fc,%eax
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	74 1b                	je     80105e78 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e5d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e62:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e63:	a8 01                	test   $0x1,%al
80105e65:	74 11                	je     80105e78 <uartgetc+0x28>
80105e67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e6d:	0f b6 c0             	movzbl %al,%eax
80105e70:	c3                   	ret    
80105e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e7d:	c3                   	ret    
80105e7e:	66 90                	xchg   %ax,%ax

80105e80 <uartputc.part.0>:
uartputc(int c)
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	89 c7                	mov    %eax,%edi
80105e86:	56                   	push   %esi
80105e87:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e8c:	53                   	push   %ebx
80105e8d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e92:	83 ec 0c             	sub    $0xc,%esp
80105e95:	eb 1b                	jmp    80105eb2 <uartputc.part.0+0x32>
80105e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	6a 0a                	push   $0xa
80105ea5:	e8 36 ca ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	83 eb 01             	sub    $0x1,%ebx
80105eb0:	74 07                	je     80105eb9 <uartputc.part.0+0x39>
80105eb2:	89 f2                	mov    %esi,%edx
80105eb4:	ec                   	in     (%dx),%al
80105eb5:	a8 20                	test   $0x20,%al
80105eb7:	74 e7                	je     80105ea0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105eb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebe:	89 f8                	mov    %edi,%eax
80105ec0:	ee                   	out    %al,(%dx)
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <uartinit>:
{
80105ed0:	f3 0f 1e fb          	endbr32 
80105ed4:	55                   	push   %ebp
80105ed5:	31 c9                	xor    %ecx,%ecx
80105ed7:	89 c8                	mov    %ecx,%eax
80105ed9:	89 e5                	mov    %esp,%ebp
80105edb:	57                   	push   %edi
80105edc:	56                   	push   %esi
80105edd:	53                   	push   %ebx
80105ede:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105ee3:	89 da                	mov    %ebx,%edx
80105ee5:	83 ec 0c             	sub    $0xc,%esp
80105ee8:	ee                   	out    %al,(%dx)
80105ee9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105eee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ef3:	89 fa                	mov    %edi,%edx
80105ef5:	ee                   	out    %al,(%dx)
80105ef6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105efb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f00:	ee                   	out    %al,(%dx)
80105f01:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f06:	89 c8                	mov    %ecx,%eax
80105f08:	89 f2                	mov    %esi,%edx
80105f0a:	ee                   	out    %al,(%dx)
80105f0b:	b8 03 00 00 00       	mov    $0x3,%eax
80105f10:	89 fa                	mov    %edi,%edx
80105f12:	ee                   	out    %al,(%dx)
80105f13:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f18:	89 c8                	mov    %ecx,%eax
80105f1a:	ee                   	out    %al,(%dx)
80105f1b:	b8 01 00 00 00       	mov    $0x1,%eax
80105f20:	89 f2                	mov    %esi,%edx
80105f22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f23:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f28:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f29:	3c ff                	cmp    $0xff,%al
80105f2b:	74 52                	je     80105f7f <uartinit+0xaf>
  uart = 1;
80105f2d:	c7 05 fc c8 10 80 01 	movl   $0x1,0x8010c8fc
80105f34:	00 00 00 
80105f37:	89 da                	mov    %ebx,%edx
80105f39:	ec                   	in     (%dx),%al
80105f3a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f40:	83 ec 08             	sub    $0x8,%esp
80105f43:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105f48:	bb 2c 7d 10 80       	mov    $0x80107d2c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f4d:	6a 00                	push   $0x0
80105f4f:	6a 04                	push   $0x4
80105f51:	e8 da c4 ff ff       	call   80102430 <ioapicenable>
80105f56:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f59:	b8 78 00 00 00       	mov    $0x78,%eax
80105f5e:	eb 04                	jmp    80105f64 <uartinit+0x94>
80105f60:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105f64:	8b 15 fc c8 10 80    	mov    0x8010c8fc,%edx
80105f6a:	85 d2                	test   %edx,%edx
80105f6c:	74 08                	je     80105f76 <uartinit+0xa6>
    uartputc(*p);
80105f6e:	0f be c0             	movsbl %al,%eax
80105f71:	e8 0a ff ff ff       	call   80105e80 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105f76:	89 f0                	mov    %esi,%eax
80105f78:	83 c3 01             	add    $0x1,%ebx
80105f7b:	84 c0                	test   %al,%al
80105f7d:	75 e1                	jne    80105f60 <uartinit+0x90>
}
80105f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f82:	5b                   	pop    %ebx
80105f83:	5e                   	pop    %esi
80105f84:	5f                   	pop    %edi
80105f85:	5d                   	pop    %ebp
80105f86:	c3                   	ret    
80105f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <uartputc>:
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
  if(!uart)
80105f95:	8b 15 fc c8 10 80    	mov    0x8010c8fc,%edx
{
80105f9b:	89 e5                	mov    %esp,%ebp
80105f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105fa0:	85 d2                	test   %edx,%edx
80105fa2:	74 0c                	je     80105fb0 <uartputc+0x20>
}
80105fa4:	5d                   	pop    %ebp
80105fa5:	e9 d6 fe ff ff       	jmp    80105e80 <uartputc.part.0>
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fb0:	5d                   	pop    %ebp
80105fb1:	c3                   	ret    
80105fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fc0 <uartintr>:

void
uartintr(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
80105fc5:	89 e5                	mov    %esp,%ebp
80105fc7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fca:	68 50 5e 10 80       	push   $0x80105e50
80105fcf:	e8 8c a8 ff ff       	call   80100860 <consoleintr>
}
80105fd4:	83 c4 10             	add    $0x10,%esp
80105fd7:	c9                   	leave  
80105fd8:	c3                   	ret    

80105fd9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $0
80105fdb:	6a 00                	push   $0x0
  jmp alltraps
80105fdd:	e9 43 fb ff ff       	jmp    80105b25 <alltraps>

80105fe2 <vector1>:
.globl vector1
vector1:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $1
80105fe4:	6a 01                	push   $0x1
  jmp alltraps
80105fe6:	e9 3a fb ff ff       	jmp    80105b25 <alltraps>

80105feb <vector2>:
.globl vector2
vector2:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $2
80105fed:	6a 02                	push   $0x2
  jmp alltraps
80105fef:	e9 31 fb ff ff       	jmp    80105b25 <alltraps>

80105ff4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $3
80105ff6:	6a 03                	push   $0x3
  jmp alltraps
80105ff8:	e9 28 fb ff ff       	jmp    80105b25 <alltraps>

80105ffd <vector4>:
.globl vector4
vector4:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $4
80105fff:	6a 04                	push   $0x4
  jmp alltraps
80106001:	e9 1f fb ff ff       	jmp    80105b25 <alltraps>

80106006 <vector5>:
.globl vector5
vector5:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $5
80106008:	6a 05                	push   $0x5
  jmp alltraps
8010600a:	e9 16 fb ff ff       	jmp    80105b25 <alltraps>

8010600f <vector6>:
.globl vector6
vector6:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $6
80106011:	6a 06                	push   $0x6
  jmp alltraps
80106013:	e9 0d fb ff ff       	jmp    80105b25 <alltraps>

80106018 <vector7>:
.globl vector7
vector7:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $7
8010601a:	6a 07                	push   $0x7
  jmp alltraps
8010601c:	e9 04 fb ff ff       	jmp    80105b25 <alltraps>

80106021 <vector8>:
.globl vector8
vector8:
  pushl $8
80106021:	6a 08                	push   $0x8
  jmp alltraps
80106023:	e9 fd fa ff ff       	jmp    80105b25 <alltraps>

80106028 <vector9>:
.globl vector9
vector9:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $9
8010602a:	6a 09                	push   $0x9
  jmp alltraps
8010602c:	e9 f4 fa ff ff       	jmp    80105b25 <alltraps>

80106031 <vector10>:
.globl vector10
vector10:
  pushl $10
80106031:	6a 0a                	push   $0xa
  jmp alltraps
80106033:	e9 ed fa ff ff       	jmp    80105b25 <alltraps>

80106038 <vector11>:
.globl vector11
vector11:
  pushl $11
80106038:	6a 0b                	push   $0xb
  jmp alltraps
8010603a:	e9 e6 fa ff ff       	jmp    80105b25 <alltraps>

8010603f <vector12>:
.globl vector12
vector12:
  pushl $12
8010603f:	6a 0c                	push   $0xc
  jmp alltraps
80106041:	e9 df fa ff ff       	jmp    80105b25 <alltraps>

80106046 <vector13>:
.globl vector13
vector13:
  pushl $13
80106046:	6a 0d                	push   $0xd
  jmp alltraps
80106048:	e9 d8 fa ff ff       	jmp    80105b25 <alltraps>

8010604d <vector14>:
.globl vector14
vector14:
  pushl $14
8010604d:	6a 0e                	push   $0xe
  jmp alltraps
8010604f:	e9 d1 fa ff ff       	jmp    80105b25 <alltraps>

80106054 <vector15>:
.globl vector15
vector15:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $15
80106056:	6a 0f                	push   $0xf
  jmp alltraps
80106058:	e9 c8 fa ff ff       	jmp    80105b25 <alltraps>

8010605d <vector16>:
.globl vector16
vector16:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $16
8010605f:	6a 10                	push   $0x10
  jmp alltraps
80106061:	e9 bf fa ff ff       	jmp    80105b25 <alltraps>

80106066 <vector17>:
.globl vector17
vector17:
  pushl $17
80106066:	6a 11                	push   $0x11
  jmp alltraps
80106068:	e9 b8 fa ff ff       	jmp    80105b25 <alltraps>

8010606d <vector18>:
.globl vector18
vector18:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $18
8010606f:	6a 12                	push   $0x12
  jmp alltraps
80106071:	e9 af fa ff ff       	jmp    80105b25 <alltraps>

80106076 <vector19>:
.globl vector19
vector19:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $19
80106078:	6a 13                	push   $0x13
  jmp alltraps
8010607a:	e9 a6 fa ff ff       	jmp    80105b25 <alltraps>

8010607f <vector20>:
.globl vector20
vector20:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $20
80106081:	6a 14                	push   $0x14
  jmp alltraps
80106083:	e9 9d fa ff ff       	jmp    80105b25 <alltraps>

80106088 <vector21>:
.globl vector21
vector21:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $21
8010608a:	6a 15                	push   $0x15
  jmp alltraps
8010608c:	e9 94 fa ff ff       	jmp    80105b25 <alltraps>

80106091 <vector22>:
.globl vector22
vector22:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $22
80106093:	6a 16                	push   $0x16
  jmp alltraps
80106095:	e9 8b fa ff ff       	jmp    80105b25 <alltraps>

8010609a <vector23>:
.globl vector23
vector23:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $23
8010609c:	6a 17                	push   $0x17
  jmp alltraps
8010609e:	e9 82 fa ff ff       	jmp    80105b25 <alltraps>

801060a3 <vector24>:
.globl vector24
vector24:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $24
801060a5:	6a 18                	push   $0x18
  jmp alltraps
801060a7:	e9 79 fa ff ff       	jmp    80105b25 <alltraps>

801060ac <vector25>:
.globl vector25
vector25:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $25
801060ae:	6a 19                	push   $0x19
  jmp alltraps
801060b0:	e9 70 fa ff ff       	jmp    80105b25 <alltraps>

801060b5 <vector26>:
.globl vector26
vector26:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $26
801060b7:	6a 1a                	push   $0x1a
  jmp alltraps
801060b9:	e9 67 fa ff ff       	jmp    80105b25 <alltraps>

801060be <vector27>:
.globl vector27
vector27:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $27
801060c0:	6a 1b                	push   $0x1b
  jmp alltraps
801060c2:	e9 5e fa ff ff       	jmp    80105b25 <alltraps>

801060c7 <vector28>:
.globl vector28
vector28:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $28
801060c9:	6a 1c                	push   $0x1c
  jmp alltraps
801060cb:	e9 55 fa ff ff       	jmp    80105b25 <alltraps>

801060d0 <vector29>:
.globl vector29
vector29:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $29
801060d2:	6a 1d                	push   $0x1d
  jmp alltraps
801060d4:	e9 4c fa ff ff       	jmp    80105b25 <alltraps>

801060d9 <vector30>:
.globl vector30
vector30:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $30
801060db:	6a 1e                	push   $0x1e
  jmp alltraps
801060dd:	e9 43 fa ff ff       	jmp    80105b25 <alltraps>

801060e2 <vector31>:
.globl vector31
vector31:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $31
801060e4:	6a 1f                	push   $0x1f
  jmp alltraps
801060e6:	e9 3a fa ff ff       	jmp    80105b25 <alltraps>

801060eb <vector32>:
.globl vector32
vector32:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $32
801060ed:	6a 20                	push   $0x20
  jmp alltraps
801060ef:	e9 31 fa ff ff       	jmp    80105b25 <alltraps>

801060f4 <vector33>:
.globl vector33
vector33:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $33
801060f6:	6a 21                	push   $0x21
  jmp alltraps
801060f8:	e9 28 fa ff ff       	jmp    80105b25 <alltraps>

801060fd <vector34>:
.globl vector34
vector34:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $34
801060ff:	6a 22                	push   $0x22
  jmp alltraps
80106101:	e9 1f fa ff ff       	jmp    80105b25 <alltraps>

80106106 <vector35>:
.globl vector35
vector35:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $35
80106108:	6a 23                	push   $0x23
  jmp alltraps
8010610a:	e9 16 fa ff ff       	jmp    80105b25 <alltraps>

8010610f <vector36>:
.globl vector36
vector36:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $36
80106111:	6a 24                	push   $0x24
  jmp alltraps
80106113:	e9 0d fa ff ff       	jmp    80105b25 <alltraps>

80106118 <vector37>:
.globl vector37
vector37:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $37
8010611a:	6a 25                	push   $0x25
  jmp alltraps
8010611c:	e9 04 fa ff ff       	jmp    80105b25 <alltraps>

80106121 <vector38>:
.globl vector38
vector38:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $38
80106123:	6a 26                	push   $0x26
  jmp alltraps
80106125:	e9 fb f9 ff ff       	jmp    80105b25 <alltraps>

8010612a <vector39>:
.globl vector39
vector39:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $39
8010612c:	6a 27                	push   $0x27
  jmp alltraps
8010612e:	e9 f2 f9 ff ff       	jmp    80105b25 <alltraps>

80106133 <vector40>:
.globl vector40
vector40:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $40
80106135:	6a 28                	push   $0x28
  jmp alltraps
80106137:	e9 e9 f9 ff ff       	jmp    80105b25 <alltraps>

8010613c <vector41>:
.globl vector41
vector41:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $41
8010613e:	6a 29                	push   $0x29
  jmp alltraps
80106140:	e9 e0 f9 ff ff       	jmp    80105b25 <alltraps>

80106145 <vector42>:
.globl vector42
vector42:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $42
80106147:	6a 2a                	push   $0x2a
  jmp alltraps
80106149:	e9 d7 f9 ff ff       	jmp    80105b25 <alltraps>

8010614e <vector43>:
.globl vector43
vector43:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $43
80106150:	6a 2b                	push   $0x2b
  jmp alltraps
80106152:	e9 ce f9 ff ff       	jmp    80105b25 <alltraps>

80106157 <vector44>:
.globl vector44
vector44:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $44
80106159:	6a 2c                	push   $0x2c
  jmp alltraps
8010615b:	e9 c5 f9 ff ff       	jmp    80105b25 <alltraps>

80106160 <vector45>:
.globl vector45
vector45:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $45
80106162:	6a 2d                	push   $0x2d
  jmp alltraps
80106164:	e9 bc f9 ff ff       	jmp    80105b25 <alltraps>

80106169 <vector46>:
.globl vector46
vector46:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $46
8010616b:	6a 2e                	push   $0x2e
  jmp alltraps
8010616d:	e9 b3 f9 ff ff       	jmp    80105b25 <alltraps>

80106172 <vector47>:
.globl vector47
vector47:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $47
80106174:	6a 2f                	push   $0x2f
  jmp alltraps
80106176:	e9 aa f9 ff ff       	jmp    80105b25 <alltraps>

8010617b <vector48>:
.globl vector48
vector48:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $48
8010617d:	6a 30                	push   $0x30
  jmp alltraps
8010617f:	e9 a1 f9 ff ff       	jmp    80105b25 <alltraps>

80106184 <vector49>:
.globl vector49
vector49:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $49
80106186:	6a 31                	push   $0x31
  jmp alltraps
80106188:	e9 98 f9 ff ff       	jmp    80105b25 <alltraps>

8010618d <vector50>:
.globl vector50
vector50:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $50
8010618f:	6a 32                	push   $0x32
  jmp alltraps
80106191:	e9 8f f9 ff ff       	jmp    80105b25 <alltraps>

80106196 <vector51>:
.globl vector51
vector51:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $51
80106198:	6a 33                	push   $0x33
  jmp alltraps
8010619a:	e9 86 f9 ff ff       	jmp    80105b25 <alltraps>

8010619f <vector52>:
.globl vector52
vector52:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $52
801061a1:	6a 34                	push   $0x34
  jmp alltraps
801061a3:	e9 7d f9 ff ff       	jmp    80105b25 <alltraps>

801061a8 <vector53>:
.globl vector53
vector53:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $53
801061aa:	6a 35                	push   $0x35
  jmp alltraps
801061ac:	e9 74 f9 ff ff       	jmp    80105b25 <alltraps>

801061b1 <vector54>:
.globl vector54
vector54:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $54
801061b3:	6a 36                	push   $0x36
  jmp alltraps
801061b5:	e9 6b f9 ff ff       	jmp    80105b25 <alltraps>

801061ba <vector55>:
.globl vector55
vector55:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $55
801061bc:	6a 37                	push   $0x37
  jmp alltraps
801061be:	e9 62 f9 ff ff       	jmp    80105b25 <alltraps>

801061c3 <vector56>:
.globl vector56
vector56:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $56
801061c5:	6a 38                	push   $0x38
  jmp alltraps
801061c7:	e9 59 f9 ff ff       	jmp    80105b25 <alltraps>

801061cc <vector57>:
.globl vector57
vector57:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $57
801061ce:	6a 39                	push   $0x39
  jmp alltraps
801061d0:	e9 50 f9 ff ff       	jmp    80105b25 <alltraps>

801061d5 <vector58>:
.globl vector58
vector58:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $58
801061d7:	6a 3a                	push   $0x3a
  jmp alltraps
801061d9:	e9 47 f9 ff ff       	jmp    80105b25 <alltraps>

801061de <vector59>:
.globl vector59
vector59:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $59
801061e0:	6a 3b                	push   $0x3b
  jmp alltraps
801061e2:	e9 3e f9 ff ff       	jmp    80105b25 <alltraps>

801061e7 <vector60>:
.globl vector60
vector60:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $60
801061e9:	6a 3c                	push   $0x3c
  jmp alltraps
801061eb:	e9 35 f9 ff ff       	jmp    80105b25 <alltraps>

801061f0 <vector61>:
.globl vector61
vector61:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $61
801061f2:	6a 3d                	push   $0x3d
  jmp alltraps
801061f4:	e9 2c f9 ff ff       	jmp    80105b25 <alltraps>

801061f9 <vector62>:
.globl vector62
vector62:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $62
801061fb:	6a 3e                	push   $0x3e
  jmp alltraps
801061fd:	e9 23 f9 ff ff       	jmp    80105b25 <alltraps>

80106202 <vector63>:
.globl vector63
vector63:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $63
80106204:	6a 3f                	push   $0x3f
  jmp alltraps
80106206:	e9 1a f9 ff ff       	jmp    80105b25 <alltraps>

8010620b <vector64>:
.globl vector64
vector64:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $64
8010620d:	6a 40                	push   $0x40
  jmp alltraps
8010620f:	e9 11 f9 ff ff       	jmp    80105b25 <alltraps>

80106214 <vector65>:
.globl vector65
vector65:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $65
80106216:	6a 41                	push   $0x41
  jmp alltraps
80106218:	e9 08 f9 ff ff       	jmp    80105b25 <alltraps>

8010621d <vector66>:
.globl vector66
vector66:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $66
8010621f:	6a 42                	push   $0x42
  jmp alltraps
80106221:	e9 ff f8 ff ff       	jmp    80105b25 <alltraps>

80106226 <vector67>:
.globl vector67
vector67:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $67
80106228:	6a 43                	push   $0x43
  jmp alltraps
8010622a:	e9 f6 f8 ff ff       	jmp    80105b25 <alltraps>

8010622f <vector68>:
.globl vector68
vector68:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $68
80106231:	6a 44                	push   $0x44
  jmp alltraps
80106233:	e9 ed f8 ff ff       	jmp    80105b25 <alltraps>

80106238 <vector69>:
.globl vector69
vector69:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $69
8010623a:	6a 45                	push   $0x45
  jmp alltraps
8010623c:	e9 e4 f8 ff ff       	jmp    80105b25 <alltraps>

80106241 <vector70>:
.globl vector70
vector70:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $70
80106243:	6a 46                	push   $0x46
  jmp alltraps
80106245:	e9 db f8 ff ff       	jmp    80105b25 <alltraps>

8010624a <vector71>:
.globl vector71
vector71:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $71
8010624c:	6a 47                	push   $0x47
  jmp alltraps
8010624e:	e9 d2 f8 ff ff       	jmp    80105b25 <alltraps>

80106253 <vector72>:
.globl vector72
vector72:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $72
80106255:	6a 48                	push   $0x48
  jmp alltraps
80106257:	e9 c9 f8 ff ff       	jmp    80105b25 <alltraps>

8010625c <vector73>:
.globl vector73
vector73:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $73
8010625e:	6a 49                	push   $0x49
  jmp alltraps
80106260:	e9 c0 f8 ff ff       	jmp    80105b25 <alltraps>

80106265 <vector74>:
.globl vector74
vector74:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $74
80106267:	6a 4a                	push   $0x4a
  jmp alltraps
80106269:	e9 b7 f8 ff ff       	jmp    80105b25 <alltraps>

8010626e <vector75>:
.globl vector75
vector75:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $75
80106270:	6a 4b                	push   $0x4b
  jmp alltraps
80106272:	e9 ae f8 ff ff       	jmp    80105b25 <alltraps>

80106277 <vector76>:
.globl vector76
vector76:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $76
80106279:	6a 4c                	push   $0x4c
  jmp alltraps
8010627b:	e9 a5 f8 ff ff       	jmp    80105b25 <alltraps>

80106280 <vector77>:
.globl vector77
vector77:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $77
80106282:	6a 4d                	push   $0x4d
  jmp alltraps
80106284:	e9 9c f8 ff ff       	jmp    80105b25 <alltraps>

80106289 <vector78>:
.globl vector78
vector78:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $78
8010628b:	6a 4e                	push   $0x4e
  jmp alltraps
8010628d:	e9 93 f8 ff ff       	jmp    80105b25 <alltraps>

80106292 <vector79>:
.globl vector79
vector79:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $79
80106294:	6a 4f                	push   $0x4f
  jmp alltraps
80106296:	e9 8a f8 ff ff       	jmp    80105b25 <alltraps>

8010629b <vector80>:
.globl vector80
vector80:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $80
8010629d:	6a 50                	push   $0x50
  jmp alltraps
8010629f:	e9 81 f8 ff ff       	jmp    80105b25 <alltraps>

801062a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $81
801062a6:	6a 51                	push   $0x51
  jmp alltraps
801062a8:	e9 78 f8 ff ff       	jmp    80105b25 <alltraps>

801062ad <vector82>:
.globl vector82
vector82:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $82
801062af:	6a 52                	push   $0x52
  jmp alltraps
801062b1:	e9 6f f8 ff ff       	jmp    80105b25 <alltraps>

801062b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $83
801062b8:	6a 53                	push   $0x53
  jmp alltraps
801062ba:	e9 66 f8 ff ff       	jmp    80105b25 <alltraps>

801062bf <vector84>:
.globl vector84
vector84:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $84
801062c1:	6a 54                	push   $0x54
  jmp alltraps
801062c3:	e9 5d f8 ff ff       	jmp    80105b25 <alltraps>

801062c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $85
801062ca:	6a 55                	push   $0x55
  jmp alltraps
801062cc:	e9 54 f8 ff ff       	jmp    80105b25 <alltraps>

801062d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $86
801062d3:	6a 56                	push   $0x56
  jmp alltraps
801062d5:	e9 4b f8 ff ff       	jmp    80105b25 <alltraps>

801062da <vector87>:
.globl vector87
vector87:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $87
801062dc:	6a 57                	push   $0x57
  jmp alltraps
801062de:	e9 42 f8 ff ff       	jmp    80105b25 <alltraps>

801062e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $88
801062e5:	6a 58                	push   $0x58
  jmp alltraps
801062e7:	e9 39 f8 ff ff       	jmp    80105b25 <alltraps>

801062ec <vector89>:
.globl vector89
vector89:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $89
801062ee:	6a 59                	push   $0x59
  jmp alltraps
801062f0:	e9 30 f8 ff ff       	jmp    80105b25 <alltraps>

801062f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $90
801062f7:	6a 5a                	push   $0x5a
  jmp alltraps
801062f9:	e9 27 f8 ff ff       	jmp    80105b25 <alltraps>

801062fe <vector91>:
.globl vector91
vector91:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $91
80106300:	6a 5b                	push   $0x5b
  jmp alltraps
80106302:	e9 1e f8 ff ff       	jmp    80105b25 <alltraps>

80106307 <vector92>:
.globl vector92
vector92:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $92
80106309:	6a 5c                	push   $0x5c
  jmp alltraps
8010630b:	e9 15 f8 ff ff       	jmp    80105b25 <alltraps>

80106310 <vector93>:
.globl vector93
vector93:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $93
80106312:	6a 5d                	push   $0x5d
  jmp alltraps
80106314:	e9 0c f8 ff ff       	jmp    80105b25 <alltraps>

80106319 <vector94>:
.globl vector94
vector94:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $94
8010631b:	6a 5e                	push   $0x5e
  jmp alltraps
8010631d:	e9 03 f8 ff ff       	jmp    80105b25 <alltraps>

80106322 <vector95>:
.globl vector95
vector95:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $95
80106324:	6a 5f                	push   $0x5f
  jmp alltraps
80106326:	e9 fa f7 ff ff       	jmp    80105b25 <alltraps>

8010632b <vector96>:
.globl vector96
vector96:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $96
8010632d:	6a 60                	push   $0x60
  jmp alltraps
8010632f:	e9 f1 f7 ff ff       	jmp    80105b25 <alltraps>

80106334 <vector97>:
.globl vector97
vector97:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $97
80106336:	6a 61                	push   $0x61
  jmp alltraps
80106338:	e9 e8 f7 ff ff       	jmp    80105b25 <alltraps>

8010633d <vector98>:
.globl vector98
vector98:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $98
8010633f:	6a 62                	push   $0x62
  jmp alltraps
80106341:	e9 df f7 ff ff       	jmp    80105b25 <alltraps>

80106346 <vector99>:
.globl vector99
vector99:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $99
80106348:	6a 63                	push   $0x63
  jmp alltraps
8010634a:	e9 d6 f7 ff ff       	jmp    80105b25 <alltraps>

8010634f <vector100>:
.globl vector100
vector100:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $100
80106351:	6a 64                	push   $0x64
  jmp alltraps
80106353:	e9 cd f7 ff ff       	jmp    80105b25 <alltraps>

80106358 <vector101>:
.globl vector101
vector101:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $101
8010635a:	6a 65                	push   $0x65
  jmp alltraps
8010635c:	e9 c4 f7 ff ff       	jmp    80105b25 <alltraps>

80106361 <vector102>:
.globl vector102
vector102:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $102
80106363:	6a 66                	push   $0x66
  jmp alltraps
80106365:	e9 bb f7 ff ff       	jmp    80105b25 <alltraps>

8010636a <vector103>:
.globl vector103
vector103:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $103
8010636c:	6a 67                	push   $0x67
  jmp alltraps
8010636e:	e9 b2 f7 ff ff       	jmp    80105b25 <alltraps>

80106373 <vector104>:
.globl vector104
vector104:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $104
80106375:	6a 68                	push   $0x68
  jmp alltraps
80106377:	e9 a9 f7 ff ff       	jmp    80105b25 <alltraps>

8010637c <vector105>:
.globl vector105
vector105:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $105
8010637e:	6a 69                	push   $0x69
  jmp alltraps
80106380:	e9 a0 f7 ff ff       	jmp    80105b25 <alltraps>

80106385 <vector106>:
.globl vector106
vector106:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $106
80106387:	6a 6a                	push   $0x6a
  jmp alltraps
80106389:	e9 97 f7 ff ff       	jmp    80105b25 <alltraps>

8010638e <vector107>:
.globl vector107
vector107:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $107
80106390:	6a 6b                	push   $0x6b
  jmp alltraps
80106392:	e9 8e f7 ff ff       	jmp    80105b25 <alltraps>

80106397 <vector108>:
.globl vector108
vector108:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $108
80106399:	6a 6c                	push   $0x6c
  jmp alltraps
8010639b:	e9 85 f7 ff ff       	jmp    80105b25 <alltraps>

801063a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801063a0:	6a 00                	push   $0x0
  pushl $109
801063a2:	6a 6d                	push   $0x6d
  jmp alltraps
801063a4:	e9 7c f7 ff ff       	jmp    80105b25 <alltraps>

801063a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801063a9:	6a 00                	push   $0x0
  pushl $110
801063ab:	6a 6e                	push   $0x6e
  jmp alltraps
801063ad:	e9 73 f7 ff ff       	jmp    80105b25 <alltraps>

801063b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $111
801063b4:	6a 6f                	push   $0x6f
  jmp alltraps
801063b6:	e9 6a f7 ff ff       	jmp    80105b25 <alltraps>

801063bb <vector112>:
.globl vector112
vector112:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $112
801063bd:	6a 70                	push   $0x70
  jmp alltraps
801063bf:	e9 61 f7 ff ff       	jmp    80105b25 <alltraps>

801063c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801063c4:	6a 00                	push   $0x0
  pushl $113
801063c6:	6a 71                	push   $0x71
  jmp alltraps
801063c8:	e9 58 f7 ff ff       	jmp    80105b25 <alltraps>

801063cd <vector114>:
.globl vector114
vector114:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $114
801063cf:	6a 72                	push   $0x72
  jmp alltraps
801063d1:	e9 4f f7 ff ff       	jmp    80105b25 <alltraps>

801063d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $115
801063d8:	6a 73                	push   $0x73
  jmp alltraps
801063da:	e9 46 f7 ff ff       	jmp    80105b25 <alltraps>

801063df <vector116>:
.globl vector116
vector116:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $116
801063e1:	6a 74                	push   $0x74
  jmp alltraps
801063e3:	e9 3d f7 ff ff       	jmp    80105b25 <alltraps>

801063e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $117
801063ea:	6a 75                	push   $0x75
  jmp alltraps
801063ec:	e9 34 f7 ff ff       	jmp    80105b25 <alltraps>

801063f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $118
801063f3:	6a 76                	push   $0x76
  jmp alltraps
801063f5:	e9 2b f7 ff ff       	jmp    80105b25 <alltraps>

801063fa <vector119>:
.globl vector119
vector119:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $119
801063fc:	6a 77                	push   $0x77
  jmp alltraps
801063fe:	e9 22 f7 ff ff       	jmp    80105b25 <alltraps>

80106403 <vector120>:
.globl vector120
vector120:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $120
80106405:	6a 78                	push   $0x78
  jmp alltraps
80106407:	e9 19 f7 ff ff       	jmp    80105b25 <alltraps>

8010640c <vector121>:
.globl vector121
vector121:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $121
8010640e:	6a 79                	push   $0x79
  jmp alltraps
80106410:	e9 10 f7 ff ff       	jmp    80105b25 <alltraps>

80106415 <vector122>:
.globl vector122
vector122:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $122
80106417:	6a 7a                	push   $0x7a
  jmp alltraps
80106419:	e9 07 f7 ff ff       	jmp    80105b25 <alltraps>

8010641e <vector123>:
.globl vector123
vector123:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $123
80106420:	6a 7b                	push   $0x7b
  jmp alltraps
80106422:	e9 fe f6 ff ff       	jmp    80105b25 <alltraps>

80106427 <vector124>:
.globl vector124
vector124:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $124
80106429:	6a 7c                	push   $0x7c
  jmp alltraps
8010642b:	e9 f5 f6 ff ff       	jmp    80105b25 <alltraps>

80106430 <vector125>:
.globl vector125
vector125:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $125
80106432:	6a 7d                	push   $0x7d
  jmp alltraps
80106434:	e9 ec f6 ff ff       	jmp    80105b25 <alltraps>

80106439 <vector126>:
.globl vector126
vector126:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $126
8010643b:	6a 7e                	push   $0x7e
  jmp alltraps
8010643d:	e9 e3 f6 ff ff       	jmp    80105b25 <alltraps>

80106442 <vector127>:
.globl vector127
vector127:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $127
80106444:	6a 7f                	push   $0x7f
  jmp alltraps
80106446:	e9 da f6 ff ff       	jmp    80105b25 <alltraps>

8010644b <vector128>:
.globl vector128
vector128:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $128
8010644d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106452:	e9 ce f6 ff ff       	jmp    80105b25 <alltraps>

80106457 <vector129>:
.globl vector129
vector129:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $129
80106459:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010645e:	e9 c2 f6 ff ff       	jmp    80105b25 <alltraps>

80106463 <vector130>:
.globl vector130
vector130:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $130
80106465:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010646a:	e9 b6 f6 ff ff       	jmp    80105b25 <alltraps>

8010646f <vector131>:
.globl vector131
vector131:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $131
80106471:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106476:	e9 aa f6 ff ff       	jmp    80105b25 <alltraps>

8010647b <vector132>:
.globl vector132
vector132:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $132
8010647d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106482:	e9 9e f6 ff ff       	jmp    80105b25 <alltraps>

80106487 <vector133>:
.globl vector133
vector133:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $133
80106489:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010648e:	e9 92 f6 ff ff       	jmp    80105b25 <alltraps>

80106493 <vector134>:
.globl vector134
vector134:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $134
80106495:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010649a:	e9 86 f6 ff ff       	jmp    80105b25 <alltraps>

8010649f <vector135>:
.globl vector135
vector135:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $135
801064a1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064a6:	e9 7a f6 ff ff       	jmp    80105b25 <alltraps>

801064ab <vector136>:
.globl vector136
vector136:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $136
801064ad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064b2:	e9 6e f6 ff ff       	jmp    80105b25 <alltraps>

801064b7 <vector137>:
.globl vector137
vector137:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $137
801064b9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064be:	e9 62 f6 ff ff       	jmp    80105b25 <alltraps>

801064c3 <vector138>:
.globl vector138
vector138:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $138
801064c5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064ca:	e9 56 f6 ff ff       	jmp    80105b25 <alltraps>

801064cf <vector139>:
.globl vector139
vector139:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $139
801064d1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064d6:	e9 4a f6 ff ff       	jmp    80105b25 <alltraps>

801064db <vector140>:
.globl vector140
vector140:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $140
801064dd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064e2:	e9 3e f6 ff ff       	jmp    80105b25 <alltraps>

801064e7 <vector141>:
.globl vector141
vector141:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $141
801064e9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ee:	e9 32 f6 ff ff       	jmp    80105b25 <alltraps>

801064f3 <vector142>:
.globl vector142
vector142:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $142
801064f5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064fa:	e9 26 f6 ff ff       	jmp    80105b25 <alltraps>

801064ff <vector143>:
.globl vector143
vector143:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $143
80106501:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106506:	e9 1a f6 ff ff       	jmp    80105b25 <alltraps>

8010650b <vector144>:
.globl vector144
vector144:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $144
8010650d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106512:	e9 0e f6 ff ff       	jmp    80105b25 <alltraps>

80106517 <vector145>:
.globl vector145
vector145:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $145
80106519:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010651e:	e9 02 f6 ff ff       	jmp    80105b25 <alltraps>

80106523 <vector146>:
.globl vector146
vector146:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $146
80106525:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010652a:	e9 f6 f5 ff ff       	jmp    80105b25 <alltraps>

8010652f <vector147>:
.globl vector147
vector147:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $147
80106531:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106536:	e9 ea f5 ff ff       	jmp    80105b25 <alltraps>

8010653b <vector148>:
.globl vector148
vector148:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $148
8010653d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106542:	e9 de f5 ff ff       	jmp    80105b25 <alltraps>

80106547 <vector149>:
.globl vector149
vector149:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $149
80106549:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010654e:	e9 d2 f5 ff ff       	jmp    80105b25 <alltraps>

80106553 <vector150>:
.globl vector150
vector150:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $150
80106555:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010655a:	e9 c6 f5 ff ff       	jmp    80105b25 <alltraps>

8010655f <vector151>:
.globl vector151
vector151:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $151
80106561:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106566:	e9 ba f5 ff ff       	jmp    80105b25 <alltraps>

8010656b <vector152>:
.globl vector152
vector152:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $152
8010656d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106572:	e9 ae f5 ff ff       	jmp    80105b25 <alltraps>

80106577 <vector153>:
.globl vector153
vector153:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $153
80106579:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010657e:	e9 a2 f5 ff ff       	jmp    80105b25 <alltraps>

80106583 <vector154>:
.globl vector154
vector154:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $154
80106585:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010658a:	e9 96 f5 ff ff       	jmp    80105b25 <alltraps>

8010658f <vector155>:
.globl vector155
vector155:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $155
80106591:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106596:	e9 8a f5 ff ff       	jmp    80105b25 <alltraps>

8010659b <vector156>:
.globl vector156
vector156:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $156
8010659d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065a2:	e9 7e f5 ff ff       	jmp    80105b25 <alltraps>

801065a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $157
801065a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ae:	e9 72 f5 ff ff       	jmp    80105b25 <alltraps>

801065b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $158
801065b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065ba:	e9 66 f5 ff ff       	jmp    80105b25 <alltraps>

801065bf <vector159>:
.globl vector159
vector159:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $159
801065c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065c6:	e9 5a f5 ff ff       	jmp    80105b25 <alltraps>

801065cb <vector160>:
.globl vector160
vector160:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $160
801065cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065d2:	e9 4e f5 ff ff       	jmp    80105b25 <alltraps>

801065d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $161
801065d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065de:	e9 42 f5 ff ff       	jmp    80105b25 <alltraps>

801065e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $162
801065e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065ea:	e9 36 f5 ff ff       	jmp    80105b25 <alltraps>

801065ef <vector163>:
.globl vector163
vector163:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $163
801065f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065f6:	e9 2a f5 ff ff       	jmp    80105b25 <alltraps>

801065fb <vector164>:
.globl vector164
vector164:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $164
801065fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106602:	e9 1e f5 ff ff       	jmp    80105b25 <alltraps>

80106607 <vector165>:
.globl vector165
vector165:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $165
80106609:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010660e:	e9 12 f5 ff ff       	jmp    80105b25 <alltraps>

80106613 <vector166>:
.globl vector166
vector166:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $166
80106615:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010661a:	e9 06 f5 ff ff       	jmp    80105b25 <alltraps>

8010661f <vector167>:
.globl vector167
vector167:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $167
80106621:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106626:	e9 fa f4 ff ff       	jmp    80105b25 <alltraps>

8010662b <vector168>:
.globl vector168
vector168:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $168
8010662d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106632:	e9 ee f4 ff ff       	jmp    80105b25 <alltraps>

80106637 <vector169>:
.globl vector169
vector169:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $169
80106639:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010663e:	e9 e2 f4 ff ff       	jmp    80105b25 <alltraps>

80106643 <vector170>:
.globl vector170
vector170:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $170
80106645:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010664a:	e9 d6 f4 ff ff       	jmp    80105b25 <alltraps>

8010664f <vector171>:
.globl vector171
vector171:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $171
80106651:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106656:	e9 ca f4 ff ff       	jmp    80105b25 <alltraps>

8010665b <vector172>:
.globl vector172
vector172:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $172
8010665d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106662:	e9 be f4 ff ff       	jmp    80105b25 <alltraps>

80106667 <vector173>:
.globl vector173
vector173:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $173
80106669:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010666e:	e9 b2 f4 ff ff       	jmp    80105b25 <alltraps>

80106673 <vector174>:
.globl vector174
vector174:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $174
80106675:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010667a:	e9 a6 f4 ff ff       	jmp    80105b25 <alltraps>

8010667f <vector175>:
.globl vector175
vector175:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $175
80106681:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106686:	e9 9a f4 ff ff       	jmp    80105b25 <alltraps>

8010668b <vector176>:
.globl vector176
vector176:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $176
8010668d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106692:	e9 8e f4 ff ff       	jmp    80105b25 <alltraps>

80106697 <vector177>:
.globl vector177
vector177:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $177
80106699:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010669e:	e9 82 f4 ff ff       	jmp    80105b25 <alltraps>

801066a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $178
801066a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066aa:	e9 76 f4 ff ff       	jmp    80105b25 <alltraps>

801066af <vector179>:
.globl vector179
vector179:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $179
801066b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066b6:	e9 6a f4 ff ff       	jmp    80105b25 <alltraps>

801066bb <vector180>:
.globl vector180
vector180:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $180
801066bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066c2:	e9 5e f4 ff ff       	jmp    80105b25 <alltraps>

801066c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $181
801066c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ce:	e9 52 f4 ff ff       	jmp    80105b25 <alltraps>

801066d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $182
801066d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066da:	e9 46 f4 ff ff       	jmp    80105b25 <alltraps>

801066df <vector183>:
.globl vector183
vector183:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $183
801066e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066e6:	e9 3a f4 ff ff       	jmp    80105b25 <alltraps>

801066eb <vector184>:
.globl vector184
vector184:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $184
801066ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066f2:	e9 2e f4 ff ff       	jmp    80105b25 <alltraps>

801066f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $185
801066f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066fe:	e9 22 f4 ff ff       	jmp    80105b25 <alltraps>

80106703 <vector186>:
.globl vector186
vector186:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $186
80106705:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010670a:	e9 16 f4 ff ff       	jmp    80105b25 <alltraps>

8010670f <vector187>:
.globl vector187
vector187:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $187
80106711:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106716:	e9 0a f4 ff ff       	jmp    80105b25 <alltraps>

8010671b <vector188>:
.globl vector188
vector188:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $188
8010671d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106722:	e9 fe f3 ff ff       	jmp    80105b25 <alltraps>

80106727 <vector189>:
.globl vector189
vector189:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $189
80106729:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010672e:	e9 f2 f3 ff ff       	jmp    80105b25 <alltraps>

80106733 <vector190>:
.globl vector190
vector190:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $190
80106735:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010673a:	e9 e6 f3 ff ff       	jmp    80105b25 <alltraps>

8010673f <vector191>:
.globl vector191
vector191:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $191
80106741:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106746:	e9 da f3 ff ff       	jmp    80105b25 <alltraps>

8010674b <vector192>:
.globl vector192
vector192:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $192
8010674d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106752:	e9 ce f3 ff ff       	jmp    80105b25 <alltraps>

80106757 <vector193>:
.globl vector193
vector193:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $193
80106759:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010675e:	e9 c2 f3 ff ff       	jmp    80105b25 <alltraps>

80106763 <vector194>:
.globl vector194
vector194:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $194
80106765:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010676a:	e9 b6 f3 ff ff       	jmp    80105b25 <alltraps>

8010676f <vector195>:
.globl vector195
vector195:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $195
80106771:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106776:	e9 aa f3 ff ff       	jmp    80105b25 <alltraps>

8010677b <vector196>:
.globl vector196
vector196:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $196
8010677d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106782:	e9 9e f3 ff ff       	jmp    80105b25 <alltraps>

80106787 <vector197>:
.globl vector197
vector197:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $197
80106789:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010678e:	e9 92 f3 ff ff       	jmp    80105b25 <alltraps>

80106793 <vector198>:
.globl vector198
vector198:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $198
80106795:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010679a:	e9 86 f3 ff ff       	jmp    80105b25 <alltraps>

8010679f <vector199>:
.globl vector199
vector199:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $199
801067a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067a6:	e9 7a f3 ff ff       	jmp    80105b25 <alltraps>

801067ab <vector200>:
.globl vector200
vector200:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $200
801067ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067b2:	e9 6e f3 ff ff       	jmp    80105b25 <alltraps>

801067b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $201
801067b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067be:	e9 62 f3 ff ff       	jmp    80105b25 <alltraps>

801067c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $202
801067c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067ca:	e9 56 f3 ff ff       	jmp    80105b25 <alltraps>

801067cf <vector203>:
.globl vector203
vector203:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $203
801067d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067d6:	e9 4a f3 ff ff       	jmp    80105b25 <alltraps>

801067db <vector204>:
.globl vector204
vector204:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $204
801067dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067e2:	e9 3e f3 ff ff       	jmp    80105b25 <alltraps>

801067e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $205
801067e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ee:	e9 32 f3 ff ff       	jmp    80105b25 <alltraps>

801067f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $206
801067f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067fa:	e9 26 f3 ff ff       	jmp    80105b25 <alltraps>

801067ff <vector207>:
.globl vector207
vector207:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $207
80106801:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106806:	e9 1a f3 ff ff       	jmp    80105b25 <alltraps>

8010680b <vector208>:
.globl vector208
vector208:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $208
8010680d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106812:	e9 0e f3 ff ff       	jmp    80105b25 <alltraps>

80106817 <vector209>:
.globl vector209
vector209:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $209
80106819:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010681e:	e9 02 f3 ff ff       	jmp    80105b25 <alltraps>

80106823 <vector210>:
.globl vector210
vector210:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $210
80106825:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010682a:	e9 f6 f2 ff ff       	jmp    80105b25 <alltraps>

8010682f <vector211>:
.globl vector211
vector211:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $211
80106831:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106836:	e9 ea f2 ff ff       	jmp    80105b25 <alltraps>

8010683b <vector212>:
.globl vector212
vector212:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $212
8010683d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106842:	e9 de f2 ff ff       	jmp    80105b25 <alltraps>

80106847 <vector213>:
.globl vector213
vector213:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $213
80106849:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010684e:	e9 d2 f2 ff ff       	jmp    80105b25 <alltraps>

80106853 <vector214>:
.globl vector214
vector214:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $214
80106855:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010685a:	e9 c6 f2 ff ff       	jmp    80105b25 <alltraps>

8010685f <vector215>:
.globl vector215
vector215:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $215
80106861:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106866:	e9 ba f2 ff ff       	jmp    80105b25 <alltraps>

8010686b <vector216>:
.globl vector216
vector216:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $216
8010686d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106872:	e9 ae f2 ff ff       	jmp    80105b25 <alltraps>

80106877 <vector217>:
.globl vector217
vector217:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $217
80106879:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010687e:	e9 a2 f2 ff ff       	jmp    80105b25 <alltraps>

80106883 <vector218>:
.globl vector218
vector218:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $218
80106885:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010688a:	e9 96 f2 ff ff       	jmp    80105b25 <alltraps>

8010688f <vector219>:
.globl vector219
vector219:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $219
80106891:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106896:	e9 8a f2 ff ff       	jmp    80105b25 <alltraps>

8010689b <vector220>:
.globl vector220
vector220:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $220
8010689d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068a2:	e9 7e f2 ff ff       	jmp    80105b25 <alltraps>

801068a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $221
801068a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ae:	e9 72 f2 ff ff       	jmp    80105b25 <alltraps>

801068b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $222
801068b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068ba:	e9 66 f2 ff ff       	jmp    80105b25 <alltraps>

801068bf <vector223>:
.globl vector223
vector223:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $223
801068c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068c6:	e9 5a f2 ff ff       	jmp    80105b25 <alltraps>

801068cb <vector224>:
.globl vector224
vector224:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $224
801068cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068d2:	e9 4e f2 ff ff       	jmp    80105b25 <alltraps>

801068d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $225
801068d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068de:	e9 42 f2 ff ff       	jmp    80105b25 <alltraps>

801068e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $226
801068e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068ea:	e9 36 f2 ff ff       	jmp    80105b25 <alltraps>

801068ef <vector227>:
.globl vector227
vector227:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $227
801068f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068f6:	e9 2a f2 ff ff       	jmp    80105b25 <alltraps>

801068fb <vector228>:
.globl vector228
vector228:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $228
801068fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106902:	e9 1e f2 ff ff       	jmp    80105b25 <alltraps>

80106907 <vector229>:
.globl vector229
vector229:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $229
80106909:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010690e:	e9 12 f2 ff ff       	jmp    80105b25 <alltraps>

80106913 <vector230>:
.globl vector230
vector230:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $230
80106915:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010691a:	e9 06 f2 ff ff       	jmp    80105b25 <alltraps>

8010691f <vector231>:
.globl vector231
vector231:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $231
80106921:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106926:	e9 fa f1 ff ff       	jmp    80105b25 <alltraps>

8010692b <vector232>:
.globl vector232
vector232:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $232
8010692d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106932:	e9 ee f1 ff ff       	jmp    80105b25 <alltraps>

80106937 <vector233>:
.globl vector233
vector233:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $233
80106939:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010693e:	e9 e2 f1 ff ff       	jmp    80105b25 <alltraps>

80106943 <vector234>:
.globl vector234
vector234:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $234
80106945:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010694a:	e9 d6 f1 ff ff       	jmp    80105b25 <alltraps>

8010694f <vector235>:
.globl vector235
vector235:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $235
80106951:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106956:	e9 ca f1 ff ff       	jmp    80105b25 <alltraps>

8010695b <vector236>:
.globl vector236
vector236:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $236
8010695d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106962:	e9 be f1 ff ff       	jmp    80105b25 <alltraps>

80106967 <vector237>:
.globl vector237
vector237:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $237
80106969:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010696e:	e9 b2 f1 ff ff       	jmp    80105b25 <alltraps>

80106973 <vector238>:
.globl vector238
vector238:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $238
80106975:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010697a:	e9 a6 f1 ff ff       	jmp    80105b25 <alltraps>

8010697f <vector239>:
.globl vector239
vector239:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $239
80106981:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106986:	e9 9a f1 ff ff       	jmp    80105b25 <alltraps>

8010698b <vector240>:
.globl vector240
vector240:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $240
8010698d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106992:	e9 8e f1 ff ff       	jmp    80105b25 <alltraps>

80106997 <vector241>:
.globl vector241
vector241:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $241
80106999:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010699e:	e9 82 f1 ff ff       	jmp    80105b25 <alltraps>

801069a3 <vector242>:
.globl vector242
vector242:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $242
801069a5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069aa:	e9 76 f1 ff ff       	jmp    80105b25 <alltraps>

801069af <vector243>:
.globl vector243
vector243:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $243
801069b1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069b6:	e9 6a f1 ff ff       	jmp    80105b25 <alltraps>

801069bb <vector244>:
.globl vector244
vector244:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $244
801069bd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069c2:	e9 5e f1 ff ff       	jmp    80105b25 <alltraps>

801069c7 <vector245>:
.globl vector245
vector245:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $245
801069c9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ce:	e9 52 f1 ff ff       	jmp    80105b25 <alltraps>

801069d3 <vector246>:
.globl vector246
vector246:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $246
801069d5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069da:	e9 46 f1 ff ff       	jmp    80105b25 <alltraps>

801069df <vector247>:
.globl vector247
vector247:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $247
801069e1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069e6:	e9 3a f1 ff ff       	jmp    80105b25 <alltraps>

801069eb <vector248>:
.globl vector248
vector248:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $248
801069ed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069f2:	e9 2e f1 ff ff       	jmp    80105b25 <alltraps>

801069f7 <vector249>:
.globl vector249
vector249:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $249
801069f9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069fe:	e9 22 f1 ff ff       	jmp    80105b25 <alltraps>

80106a03 <vector250>:
.globl vector250
vector250:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $250
80106a05:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a0a:	e9 16 f1 ff ff       	jmp    80105b25 <alltraps>

80106a0f <vector251>:
.globl vector251
vector251:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $251
80106a11:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a16:	e9 0a f1 ff ff       	jmp    80105b25 <alltraps>

80106a1b <vector252>:
.globl vector252
vector252:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $252
80106a1d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a22:	e9 fe f0 ff ff       	jmp    80105b25 <alltraps>

80106a27 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $253
80106a29:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a2e:	e9 f2 f0 ff ff       	jmp    80105b25 <alltraps>

80106a33 <vector254>:
.globl vector254
vector254:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $254
80106a35:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a3a:	e9 e6 f0 ff ff       	jmp    80105b25 <alltraps>

80106a3f <vector255>:
.globl vector255
vector255:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $255
80106a41:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a46:	e9 da f0 ff ff       	jmp    80105b25 <alltraps>
80106a4b:	66 90                	xchg   %ax,%ax
80106a4d:	66 90                	xchg   %ax,%ax
80106a4f:	90                   	nop

80106a50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a57:	c1 ea 16             	shr    $0x16,%edx
{
80106a5a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106a5b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106a5e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a61:	8b 1f                	mov    (%edi),%ebx
80106a63:	f6 c3 01             	test   $0x1,%bl
80106a66:	74 28                	je     80106a90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106a6e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a74:	89 f0                	mov    %esi,%eax
}
80106a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a79:	c1 e8 0a             	shr    $0xa,%eax
80106a7c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106a81:	01 d8                	add    %ebx,%eax
}
80106a83:	5b                   	pop    %ebx
80106a84:	5e                   	pop    %esi
80106a85:	5f                   	pop    %edi
80106a86:	5d                   	pop    %ebp
80106a87:	c3                   	ret    
80106a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a8f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a90:	85 c9                	test   %ecx,%ecx
80106a92:	74 2c                	je     80106ac0 <walkpgdir+0x70>
80106a94:	e8 97 bb ff ff       	call   80102630 <kalloc>
80106a99:	89 c3                	mov    %eax,%ebx
80106a9b:	85 c0                	test   %eax,%eax
80106a9d:	74 21                	je     80106ac0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106a9f:	83 ec 04             	sub    $0x4,%esp
80106aa2:	68 00 10 00 00       	push   $0x1000
80106aa7:	6a 00                	push   $0x0
80106aa9:	50                   	push   %eax
80106aaa:	e8 e1 dc ff ff       	call   80104790 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aaf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ab5:	83 c4 10             	add    $0x10,%esp
80106ab8:	83 c8 07             	or     $0x7,%eax
80106abb:	89 07                	mov    %eax,(%edi)
80106abd:	eb b5                	jmp    80106a74 <walkpgdir+0x24>
80106abf:	90                   	nop
}
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ac3:	31 c0                	xor    %eax,%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ad6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106ada:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106adb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106ae0:	89 d6                	mov    %edx,%esi
{
80106ae2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ae3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106ae9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106aec:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106aef:	8b 45 08             	mov    0x8(%ebp),%eax
80106af2:	29 f0                	sub    %esi,%eax
80106af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106af7:	eb 1f                	jmp    80106b18 <mappages+0x48>
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106b00:	f6 00 01             	testb  $0x1,(%eax)
80106b03:	75 45                	jne    80106b4a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b05:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106b08:	83 cb 01             	or     $0x1,%ebx
80106b0b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106b0d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106b10:	74 2e                	je     80106b40 <mappages+0x70>
      break;
    a += PGSIZE;
80106b12:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b1b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b20:	89 f2                	mov    %esi,%edx
80106b22:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106b25:	89 f8                	mov    %edi,%eax
80106b27:	e8 24 ff ff ff       	call   80106a50 <walkpgdir>
80106b2c:	85 c0                	test   %eax,%eax
80106b2e:	75 d0                	jne    80106b00 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b38:	5b                   	pop    %ebx
80106b39:	5e                   	pop    %esi
80106b3a:	5f                   	pop    %edi
80106b3b:	5d                   	pop    %ebp
80106b3c:	c3                   	ret    
80106b3d:	8d 76 00             	lea    0x0(%esi),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
      panic("remap");
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 34 7d 10 80       	push   $0x80107d34
80106b52:	e8 39 98 ff ff       	call   80100390 <panic>
80106b57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5e:	66 90                	xchg   %ax,%ax

80106b60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	89 c6                	mov    %eax,%esi
80106b67:	53                   	push   %ebx
80106b68:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b6a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106b70:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b76:	83 ec 1c             	sub    $0x1c,%esp
80106b79:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b7c:	39 da                	cmp    %ebx,%edx
80106b7e:	73 5b                	jae    80106bdb <deallocuvm.part.0+0x7b>
80106b80:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106b83:	89 d7                	mov    %edx,%edi
80106b85:	eb 14                	jmp    80106b9b <deallocuvm.part.0+0x3b>
80106b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b8e:	66 90                	xchg   %ax,%ax
80106b90:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106b96:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106b99:	76 40                	jbe    80106bdb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106b9b:	31 c9                	xor    %ecx,%ecx
80106b9d:	89 fa                	mov    %edi,%edx
80106b9f:	89 f0                	mov    %esi,%eax
80106ba1:	e8 aa fe ff ff       	call   80106a50 <walkpgdir>
80106ba6:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106ba8:	85 c0                	test   %eax,%eax
80106baa:	74 44                	je     80106bf0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106bac:	8b 00                	mov    (%eax),%eax
80106bae:	a8 01                	test   $0x1,%al
80106bb0:	74 de                	je     80106b90 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bb7:	74 47                	je     80106c00 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106bb9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106bbc:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106bc7:	50                   	push   %eax
80106bc8:	e8 a3 b8 ff ff       	call   80102470 <kfree>
      *pte = 0;
80106bcd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106bd3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106bd6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106bd9:	77 c0                	ja     80106b9b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be1:	5b                   	pop    %ebx
80106be2:	5e                   	pop    %esi
80106be3:	5f                   	pop    %edi
80106be4:	5d                   	pop    %ebp
80106be5:	c3                   	ret    
80106be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bed:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bf0:	89 fa                	mov    %edi,%edx
80106bf2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106bf8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106bfe:	eb 96                	jmp    80106b96 <deallocuvm.part.0+0x36>
        panic("kfree");
80106c00:	83 ec 0c             	sub    $0xc,%esp
80106c03:	68 a6 76 10 80       	push   $0x801076a6
80106c08:	e8 83 97 ff ff       	call   80100390 <panic>
80106c0d:	8d 76 00             	lea    0x0(%esi),%esi

80106c10 <seginit>:
{
80106c10:	f3 0f 1e fb          	endbr32 
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c1a:	e8 51 cd ff ff       	call   80103970 <cpuid>
  pd[0] = size-1;
80106c1f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c24:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106c2a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c2e:	c7 80 38 4b 11 80 ff 	movl   $0xffff,-0x7feeb4c8(%eax)
80106c35:	ff 00 00 
80106c38:	c7 80 3c 4b 11 80 00 	movl   $0xcf9a00,-0x7feeb4c4(%eax)
80106c3f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c42:	c7 80 40 4b 11 80 ff 	movl   $0xffff,-0x7feeb4c0(%eax)
80106c49:	ff 00 00 
80106c4c:	c7 80 44 4b 11 80 00 	movl   $0xcf9200,-0x7feeb4bc(%eax)
80106c53:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c56:	c7 80 48 4b 11 80 ff 	movl   $0xffff,-0x7feeb4b8(%eax)
80106c5d:	ff 00 00 
80106c60:	c7 80 4c 4b 11 80 00 	movl   $0xcffa00,-0x7feeb4b4(%eax)
80106c67:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c6a:	c7 80 50 4b 11 80 ff 	movl   $0xffff,-0x7feeb4b0(%eax)
80106c71:	ff 00 00 
80106c74:	c7 80 54 4b 11 80 00 	movl   $0xcff200,-0x7feeb4ac(%eax)
80106c7b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c7e:	05 30 4b 11 80       	add    $0x80114b30,%eax
  pd[1] = (uint)p;
80106c83:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c87:	c1 e8 10             	shr    $0x10,%eax
80106c8a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c8e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c91:	0f 01 10             	lgdtl  (%eax)
}
80106c94:	c9                   	leave  
80106c95:	c3                   	ret    
80106c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c9d:	8d 76 00             	lea    0x0(%esi),%esi

80106ca0 <switchkvm>:
{
80106ca0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ca4:	a1 a4 58 11 80       	mov    0x801158a4,%eax
80106ca9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cae:	0f 22 d8             	mov    %eax,%cr3
}
80106cb1:	c3                   	ret    
80106cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <switchuvm>:
{
80106cc0:	f3 0f 1e fb          	endbr32 
80106cc4:	55                   	push   %ebp
80106cc5:	89 e5                	mov    %esp,%ebp
80106cc7:	57                   	push   %edi
80106cc8:	56                   	push   %esi
80106cc9:	53                   	push   %ebx
80106cca:	83 ec 1c             	sub    $0x1c,%esp
80106ccd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106cd0:	85 f6                	test   %esi,%esi
80106cd2:	0f 84 cb 00 00 00    	je     80106da3 <switchuvm+0xe3>
  if(p->kstack == 0)
80106cd8:	8b 46 08             	mov    0x8(%esi),%eax
80106cdb:	85 c0                	test   %eax,%eax
80106cdd:	0f 84 da 00 00 00    	je     80106dbd <switchuvm+0xfd>
  if(p->pgdir == 0)
80106ce3:	8b 46 04             	mov    0x4(%esi),%eax
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	0f 84 c2 00 00 00    	je     80106db0 <switchuvm+0xf0>
  pushcli();
80106cee:	e8 8d d8 ff ff       	call   80104580 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cf3:	e8 08 cc ff ff       	call   80103900 <mycpu>
80106cf8:	89 c3                	mov    %eax,%ebx
80106cfa:	e8 01 cc ff ff       	call   80103900 <mycpu>
80106cff:	89 c7                	mov    %eax,%edi
80106d01:	e8 fa cb ff ff       	call   80103900 <mycpu>
80106d06:	83 c7 08             	add    $0x8,%edi
80106d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d0c:	e8 ef cb ff ff       	call   80103900 <mycpu>
80106d11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d14:	ba 67 00 00 00       	mov    $0x67,%edx
80106d19:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d20:	83 c0 08             	add    $0x8,%eax
80106d23:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d2a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d2f:	83 c1 08             	add    $0x8,%ecx
80106d32:	c1 e8 18             	shr    $0x18,%eax
80106d35:	c1 e9 10             	shr    $0x10,%ecx
80106d38:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d3e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d44:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d49:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d50:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d55:	e8 a6 cb ff ff       	call   80103900 <mycpu>
80106d5a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d61:	e8 9a cb ff ff       	call   80103900 <mycpu>
80106d66:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d6a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d73:	e8 88 cb ff ff       	call   80103900 <mycpu>
80106d78:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d7b:	e8 80 cb ff ff       	call   80103900 <mycpu>
80106d80:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d84:	b8 28 00 00 00       	mov    $0x28,%eax
80106d89:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d8c:	8b 46 04             	mov    0x4(%esi),%eax
80106d8f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d94:	0f 22 d8             	mov    %eax,%cr3
}
80106d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d9a:	5b                   	pop    %ebx
80106d9b:	5e                   	pop    %esi
80106d9c:	5f                   	pop    %edi
80106d9d:	5d                   	pop    %ebp
  popcli();
80106d9e:	e9 2d d8 ff ff       	jmp    801045d0 <popcli>
    panic("switchuvm: no process");
80106da3:	83 ec 0c             	sub    $0xc,%esp
80106da6:	68 3a 7d 10 80       	push   $0x80107d3a
80106dab:	e8 e0 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106db0:	83 ec 0c             	sub    $0xc,%esp
80106db3:	68 65 7d 10 80       	push   $0x80107d65
80106db8:	e8 d3 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106dbd:	83 ec 0c             	sub    $0xc,%esp
80106dc0:	68 50 7d 10 80       	push   $0x80107d50
80106dc5:	e8 c6 95 ff ff       	call   80100390 <panic>
80106dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dd0 <inituvm>:
{
80106dd0:	f3 0f 1e fb          	endbr32 
80106dd4:	55                   	push   %ebp
80106dd5:	89 e5                	mov    %esp,%ebp
80106dd7:	57                   	push   %edi
80106dd8:	56                   	push   %esi
80106dd9:	53                   	push   %ebx
80106dda:	83 ec 1c             	sub    $0x1c,%esp
80106ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de0:	8b 75 10             	mov    0x10(%ebp),%esi
80106de3:	8b 7d 08             	mov    0x8(%ebp),%edi
80106de6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106de9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106def:	77 4b                	ja     80106e3c <inituvm+0x6c>
  mem = kalloc();
80106df1:	e8 3a b8 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
80106df6:	83 ec 04             	sub    $0x4,%esp
80106df9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106dfe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e00:	6a 00                	push   $0x0
80106e02:	50                   	push   %eax
80106e03:	e8 88 d9 ff ff       	call   80104790 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e08:	58                   	pop    %eax
80106e09:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e0f:	5a                   	pop    %edx
80106e10:	6a 06                	push   $0x6
80106e12:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e17:	31 d2                	xor    %edx,%edx
80106e19:	50                   	push   %eax
80106e1a:	89 f8                	mov    %edi,%eax
80106e1c:	e8 af fc ff ff       	call   80106ad0 <mappages>
  memmove(mem, init, sz);
80106e21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e24:	89 75 10             	mov    %esi,0x10(%ebp)
80106e27:	83 c4 10             	add    $0x10,%esp
80106e2a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106e2d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e33:	5b                   	pop    %ebx
80106e34:	5e                   	pop    %esi
80106e35:	5f                   	pop    %edi
80106e36:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e37:	e9 f4 d9 ff ff       	jmp    80104830 <memmove>
    panic("inituvm: more than a page");
80106e3c:	83 ec 0c             	sub    $0xc,%esp
80106e3f:	68 79 7d 10 80       	push   $0x80107d79
80106e44:	e8 47 95 ff ff       	call   80100390 <panic>
80106e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e50 <loaduvm>:
{
80106e50:	f3 0f 1e fb          	endbr32 
80106e54:	55                   	push   %ebp
80106e55:	89 e5                	mov    %esp,%ebp
80106e57:	57                   	push   %edi
80106e58:	56                   	push   %esi
80106e59:	53                   	push   %ebx
80106e5a:	83 ec 1c             	sub    $0x1c,%esp
80106e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e60:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106e63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106e68:	0f 85 99 00 00 00    	jne    80106f07 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106e6e:	01 f0                	add    %esi,%eax
80106e70:	89 f3                	mov    %esi,%ebx
80106e72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e75:	8b 45 14             	mov    0x14(%ebp),%eax
80106e78:	01 f0                	add    %esi,%eax
80106e7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106e7d:	85 f6                	test   %esi,%esi
80106e7f:	75 15                	jne    80106e96 <loaduvm+0x46>
80106e81:	eb 6d                	jmp    80106ef0 <loaduvm+0xa0>
80106e83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e87:	90                   	nop
80106e88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106e8e:	89 f0                	mov    %esi,%eax
80106e90:	29 d8                	sub    %ebx,%eax
80106e92:	39 c6                	cmp    %eax,%esi
80106e94:	76 5a                	jbe    80106ef0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106e99:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9c:	31 c9                	xor    %ecx,%ecx
80106e9e:	29 da                	sub    %ebx,%edx
80106ea0:	e8 ab fb ff ff       	call   80106a50 <walkpgdir>
80106ea5:	85 c0                	test   %eax,%eax
80106ea7:	74 51                	je     80106efa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ea9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106eae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106eb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106eb8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106ebe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ec1:	29 d9                	sub    %ebx,%ecx
80106ec3:	05 00 00 00 80       	add    $0x80000000,%eax
80106ec8:	57                   	push   %edi
80106ec9:	51                   	push   %ecx
80106eca:	50                   	push   %eax
80106ecb:	ff 75 10             	pushl  0x10(%ebp)
80106ece:	e8 8d ab ff ff       	call   80101a60 <readi>
80106ed3:	83 c4 10             	add    $0x10,%esp
80106ed6:	39 f8                	cmp    %edi,%eax
80106ed8:	74 ae                	je     80106e88 <loaduvm+0x38>
}
80106eda:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ee2:	5b                   	pop    %ebx
80106ee3:	5e                   	pop    %esi
80106ee4:	5f                   	pop    %edi
80106ee5:	5d                   	pop    %ebp
80106ee6:	c3                   	ret    
80106ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eee:	66 90                	xchg   %ax,%ax
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106efa:	83 ec 0c             	sub    $0xc,%esp
80106efd:	68 93 7d 10 80       	push   $0x80107d93
80106f02:	e8 89 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106f07:	83 ec 0c             	sub    $0xc,%esp
80106f0a:	68 34 7e 10 80       	push   $0x80107e34
80106f0f:	e8 7c 94 ff ff       	call   80100390 <panic>
80106f14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f1f:	90                   	nop

80106f20 <allocuvm>:
{
80106f20:	f3 0f 1e fb          	endbr32 
80106f24:	55                   	push   %ebp
80106f25:	89 e5                	mov    %esp,%ebp
80106f27:	57                   	push   %edi
80106f28:	56                   	push   %esi
80106f29:	53                   	push   %ebx
80106f2a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f2d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106f30:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106f33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f36:	85 c0                	test   %eax,%eax
80106f38:	0f 88 b2 00 00 00    	js     80106ff0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106f3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106f44:	0f 82 96 00 00 00    	jb     80106fe0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f4a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106f50:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106f56:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f59:	77 40                	ja     80106f9b <allocuvm+0x7b>
80106f5b:	e9 83 00 00 00       	jmp    80106fe3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106f60:	83 ec 04             	sub    $0x4,%esp
80106f63:	68 00 10 00 00       	push   $0x1000
80106f68:	6a 00                	push   $0x0
80106f6a:	50                   	push   %eax
80106f6b:	e8 20 d8 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f70:	58                   	pop    %eax
80106f71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f77:	5a                   	pop    %edx
80106f78:	6a 06                	push   $0x6
80106f7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f7f:	89 f2                	mov    %esi,%edx
80106f81:	50                   	push   %eax
80106f82:	89 f8                	mov    %edi,%eax
80106f84:	e8 47 fb ff ff       	call   80106ad0 <mappages>
80106f89:	83 c4 10             	add    $0x10,%esp
80106f8c:	85 c0                	test   %eax,%eax
80106f8e:	78 78                	js     80107008 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106f90:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f96:	39 75 10             	cmp    %esi,0x10(%ebp)
80106f99:	76 48                	jbe    80106fe3 <allocuvm+0xc3>
    mem = kalloc();
80106f9b:	e8 90 b6 ff ff       	call   80102630 <kalloc>
80106fa0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fa2:	85 c0                	test   %eax,%eax
80106fa4:	75 ba                	jne    80106f60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106fa6:	83 ec 0c             	sub    $0xc,%esp
80106fa9:	68 b1 7d 10 80       	push   $0x80107db1
80106fae:	e8 fd 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fb6:	83 c4 10             	add    $0x10,%esp
80106fb9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fbc:	74 32                	je     80106ff0 <allocuvm+0xd0>
80106fbe:	8b 55 10             	mov    0x10(%ebp),%edx
80106fc1:	89 c1                	mov    %eax,%ecx
80106fc3:	89 f8                	mov    %edi,%eax
80106fc5:	e8 96 fb ff ff       	call   80106b60 <deallocuvm.part.0>
      return 0;
80106fca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fd7:	5b                   	pop    %ebx
80106fd8:	5e                   	pop    %esi
80106fd9:	5f                   	pop    %edi
80106fda:	5d                   	pop    %ebp
80106fdb:	c3                   	ret    
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106fe0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106fe6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fe9:	5b                   	pop    %ebx
80106fea:	5e                   	pop    %esi
80106feb:	5f                   	pop    %edi
80106fec:	5d                   	pop    %ebp
80106fed:	c3                   	ret    
80106fee:	66 90                	xchg   %ax,%ax
    return 0;
80106ff0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106ff7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ffd:	5b                   	pop    %ebx
80106ffe:	5e                   	pop    %esi
80106fff:	5f                   	pop    %edi
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107008:	83 ec 0c             	sub    $0xc,%esp
8010700b:	68 c9 7d 10 80       	push   $0x80107dc9
80107010:	e8 9b 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107015:	8b 45 0c             	mov    0xc(%ebp),%eax
80107018:	83 c4 10             	add    $0x10,%esp
8010701b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010701e:	74 0c                	je     8010702c <allocuvm+0x10c>
80107020:	8b 55 10             	mov    0x10(%ebp),%edx
80107023:	89 c1                	mov    %eax,%ecx
80107025:	89 f8                	mov    %edi,%eax
80107027:	e8 34 fb ff ff       	call   80106b60 <deallocuvm.part.0>
      kfree(mem);
8010702c:	83 ec 0c             	sub    $0xc,%esp
8010702f:	53                   	push   %ebx
80107030:	e8 3b b4 ff ff       	call   80102470 <kfree>
      return 0;
80107035:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010703c:	83 c4 10             	add    $0x10,%esp
}
8010703f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107050 <deallocuvm>:
{
80107050:	f3 0f 1e fb          	endbr32 
80107054:	55                   	push   %ebp
80107055:	89 e5                	mov    %esp,%ebp
80107057:	8b 55 0c             	mov    0xc(%ebp),%edx
8010705a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010705d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107060:	39 d1                	cmp    %edx,%ecx
80107062:	73 0c                	jae    80107070 <deallocuvm+0x20>
}
80107064:	5d                   	pop    %ebp
80107065:	e9 f6 fa ff ff       	jmp    80106b60 <deallocuvm.part.0>
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107070:	89 d0                	mov    %edx,%eax
80107072:	5d                   	pop    %ebp
80107073:	c3                   	ret    
80107074:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010707b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010707f:	90                   	nop

80107080 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107080:	f3 0f 1e fb          	endbr32 
80107084:	55                   	push   %ebp
80107085:	89 e5                	mov    %esp,%ebp
80107087:	57                   	push   %edi
80107088:	56                   	push   %esi
80107089:	53                   	push   %ebx
8010708a:	83 ec 0c             	sub    $0xc,%esp
8010708d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107090:	85 f6                	test   %esi,%esi
80107092:	74 55                	je     801070e9 <freevm+0x69>
  if(newsz >= oldsz)
80107094:	31 c9                	xor    %ecx,%ecx
80107096:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010709b:	89 f0                	mov    %esi,%eax
8010709d:	89 f3                	mov    %esi,%ebx
8010709f:	e8 bc fa ff ff       	call   80106b60 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070aa:	eb 0b                	jmp    801070b7 <freevm+0x37>
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070b0:	83 c3 04             	add    $0x4,%ebx
801070b3:	39 df                	cmp    %ebx,%edi
801070b5:	74 23                	je     801070da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070b7:	8b 03                	mov    (%ebx),%eax
801070b9:	a8 01                	test   $0x1,%al
801070bb:	74 f3                	je     801070b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070c2:	83 ec 0c             	sub    $0xc,%esp
801070c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070cd:	50                   	push   %eax
801070ce:	e8 9d b3 ff ff       	call   80102470 <kfree>
801070d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070d6:	39 df                	cmp    %ebx,%edi
801070d8:	75 dd                	jne    801070b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e0:	5b                   	pop    %ebx
801070e1:	5e                   	pop    %esi
801070e2:	5f                   	pop    %edi
801070e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070e4:	e9 87 b3 ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
801070e9:	83 ec 0c             	sub    $0xc,%esp
801070ec:	68 e5 7d 10 80       	push   $0x80107de5
801070f1:	e8 9a 92 ff ff       	call   80100390 <panic>
801070f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070fd:	8d 76 00             	lea    0x0(%esi),%esi

80107100 <setupkvm>:
{
80107100:	f3 0f 1e fb          	endbr32 
80107104:	55                   	push   %ebp
80107105:	89 e5                	mov    %esp,%ebp
80107107:	56                   	push   %esi
80107108:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107109:	e8 22 b5 ff ff       	call   80102630 <kalloc>
8010710e:	89 c6                	mov    %eax,%esi
80107110:	85 c0                	test   %eax,%eax
80107112:	74 42                	je     80107156 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107114:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107117:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
8010711c:	68 00 10 00 00       	push   $0x1000
80107121:	6a 00                	push   $0x0
80107123:	50                   	push   %eax
80107124:	e8 67 d6 ff ff       	call   80104790 <memset>
80107129:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010712c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010712f:	83 ec 08             	sub    $0x8,%esp
80107132:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107135:	ff 73 0c             	pushl  0xc(%ebx)
80107138:	8b 13                	mov    (%ebx),%edx
8010713a:	50                   	push   %eax
8010713b:	29 c1                	sub    %eax,%ecx
8010713d:	89 f0                	mov    %esi,%eax
8010713f:	e8 8c f9 ff ff       	call   80106ad0 <mappages>
80107144:	83 c4 10             	add    $0x10,%esp
80107147:	85 c0                	test   %eax,%eax
80107149:	78 15                	js     80107160 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010714b:	83 c3 10             	add    $0x10,%ebx
8010714e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107154:	75 d6                	jne    8010712c <setupkvm+0x2c>
}
80107156:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107159:	89 f0                	mov    %esi,%eax
8010715b:	5b                   	pop    %ebx
8010715c:	5e                   	pop    %esi
8010715d:	5d                   	pop    %ebp
8010715e:	c3                   	ret    
8010715f:	90                   	nop
      freevm(pgdir);
80107160:	83 ec 0c             	sub    $0xc,%esp
80107163:	56                   	push   %esi
      return 0;
80107164:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107166:	e8 15 ff ff ff       	call   80107080 <freevm>
      return 0;
8010716b:	83 c4 10             	add    $0x10,%esp
}
8010716e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107171:	89 f0                	mov    %esi,%eax
80107173:	5b                   	pop    %ebx
80107174:	5e                   	pop    %esi
80107175:	5d                   	pop    %ebp
80107176:	c3                   	ret    
80107177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010717e:	66 90                	xchg   %ax,%ax

80107180 <kvmalloc>:
{
80107180:	f3 0f 1e fb          	endbr32 
80107184:	55                   	push   %ebp
80107185:	89 e5                	mov    %esp,%ebp
80107187:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010718a:	e8 71 ff ff ff       	call   80107100 <setupkvm>
8010718f:	a3 a4 58 11 80       	mov    %eax,0x801158a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107194:	05 00 00 00 80       	add    $0x80000000,%eax
80107199:	0f 22 d8             	mov    %eax,%cr3
}
8010719c:	c9                   	leave  
8010719d:	c3                   	ret    
8010719e:	66 90                	xchg   %ax,%ax

801071a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071a0:	f3 0f 1e fb          	endbr32 
801071a4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071a5:	31 c9                	xor    %ecx,%ecx
{
801071a7:	89 e5                	mov    %esp,%ebp
801071a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801071af:	8b 45 08             	mov    0x8(%ebp),%eax
801071b2:	e8 99 f8 ff ff       	call   80106a50 <walkpgdir>
  if(pte == 0)
801071b7:	85 c0                	test   %eax,%eax
801071b9:	74 05                	je     801071c0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071bb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071be:	c9                   	leave  
801071bf:	c3                   	ret    
    panic("clearpteu");
801071c0:	83 ec 0c             	sub    $0xc,%esp
801071c3:	68 f6 7d 10 80       	push   $0x80107df6
801071c8:	e8 c3 91 ff ff       	call   80100390 <panic>
801071cd:	8d 76 00             	lea    0x0(%esi),%esi

801071d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071d0:	f3 0f 1e fb          	endbr32 
801071d4:	55                   	push   %ebp
801071d5:	89 e5                	mov    %esp,%ebp
801071d7:	57                   	push   %edi
801071d8:	56                   	push   %esi
801071d9:	53                   	push   %ebx
801071da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071dd:	e8 1e ff ff ff       	call   80107100 <setupkvm>
801071e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071e5:	85 c0                	test   %eax,%eax
801071e7:	0f 84 9b 00 00 00    	je     80107288 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071f0:	85 c9                	test   %ecx,%ecx
801071f2:	0f 84 90 00 00 00    	je     80107288 <copyuvm+0xb8>
801071f8:	31 f6                	xor    %esi,%esi
801071fa:	eb 46                	jmp    80107242 <copyuvm+0x72>
801071fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107200:	83 ec 04             	sub    $0x4,%esp
80107203:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107209:	68 00 10 00 00       	push   $0x1000
8010720e:	57                   	push   %edi
8010720f:	50                   	push   %eax
80107210:	e8 1b d6 ff ff       	call   80104830 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107215:	58                   	pop    %eax
80107216:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010721c:	5a                   	pop    %edx
8010721d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107220:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107225:	89 f2                	mov    %esi,%edx
80107227:	50                   	push   %eax
80107228:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010722b:	e8 a0 f8 ff ff       	call   80106ad0 <mappages>
80107230:	83 c4 10             	add    $0x10,%esp
80107233:	85 c0                	test   %eax,%eax
80107235:	78 61                	js     80107298 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107237:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010723d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107240:	76 46                	jbe    80107288 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107242:	8b 45 08             	mov    0x8(%ebp),%eax
80107245:	31 c9                	xor    %ecx,%ecx
80107247:	89 f2                	mov    %esi,%edx
80107249:	e8 02 f8 ff ff       	call   80106a50 <walkpgdir>
8010724e:	85 c0                	test   %eax,%eax
80107250:	74 61                	je     801072b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107252:	8b 00                	mov    (%eax),%eax
80107254:	a8 01                	test   $0x1,%al
80107256:	74 4e                	je     801072a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107258:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010725a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010725f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107262:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107268:	e8 c3 b3 ff ff       	call   80102630 <kalloc>
8010726d:	89 c3                	mov    %eax,%ebx
8010726f:	85 c0                	test   %eax,%eax
80107271:	75 8d                	jne    80107200 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107273:	83 ec 0c             	sub    $0xc,%esp
80107276:	ff 75 e0             	pushl  -0x20(%ebp)
80107279:	e8 02 fe ff ff       	call   80107080 <freevm>
  return 0;
8010727e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107285:	83 c4 10             	add    $0x10,%esp
}
80107288:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010728b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010728e:	5b                   	pop    %ebx
8010728f:	5e                   	pop    %esi
80107290:	5f                   	pop    %edi
80107291:	5d                   	pop    %ebp
80107292:	c3                   	ret    
80107293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107297:	90                   	nop
      kfree(mem);
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	53                   	push   %ebx
8010729c:	e8 cf b1 ff ff       	call   80102470 <kfree>
      goto bad;
801072a1:	83 c4 10             	add    $0x10,%esp
801072a4:	eb cd                	jmp    80107273 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801072a6:	83 ec 0c             	sub    $0xc,%esp
801072a9:	68 1a 7e 10 80       	push   $0x80107e1a
801072ae:	e8 dd 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801072b3:	83 ec 0c             	sub    $0xc,%esp
801072b6:	68 00 7e 10 80       	push   $0x80107e00
801072bb:	e8 d0 90 ff ff       	call   80100390 <panic>

801072c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072c0:	f3 0f 1e fb          	endbr32 
801072c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072c5:	31 c9                	xor    %ecx,%ecx
{
801072c7:	89 e5                	mov    %esp,%ebp
801072c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801072cf:	8b 45 08             	mov    0x8(%ebp),%eax
801072d2:	e8 79 f7 ff ff       	call   80106a50 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072d7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072d9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072da:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072e1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072e4:	05 00 00 00 80       	add    $0x80000000,%eax
801072e9:	83 fa 05             	cmp    $0x5,%edx
801072ec:	ba 00 00 00 00       	mov    $0x0,%edx
801072f1:	0f 45 c2             	cmovne %edx,%eax
}
801072f4:	c3                   	ret    
801072f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107300 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107300:	f3 0f 1e fb          	endbr32 
80107304:	55                   	push   %ebp
80107305:	89 e5                	mov    %esp,%ebp
80107307:	57                   	push   %edi
80107308:	56                   	push   %esi
80107309:	53                   	push   %ebx
8010730a:	83 ec 0c             	sub    $0xc,%esp
8010730d:	8b 75 14             	mov    0x14(%ebp),%esi
80107310:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107313:	85 f6                	test   %esi,%esi
80107315:	75 3c                	jne    80107353 <copyout+0x53>
80107317:	eb 67                	jmp    80107380 <copyout+0x80>
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107320:	8b 55 0c             	mov    0xc(%ebp),%edx
80107323:	89 fb                	mov    %edi,%ebx
80107325:	29 d3                	sub    %edx,%ebx
80107327:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010732d:	39 f3                	cmp    %esi,%ebx
8010732f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107332:	29 fa                	sub    %edi,%edx
80107334:	83 ec 04             	sub    $0x4,%esp
80107337:	01 c2                	add    %eax,%edx
80107339:	53                   	push   %ebx
8010733a:	ff 75 10             	pushl  0x10(%ebp)
8010733d:	52                   	push   %edx
8010733e:	e8 ed d4 ff ff       	call   80104830 <memmove>
    len -= n;
    buf += n;
80107343:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107346:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010734c:	83 c4 10             	add    $0x10,%esp
8010734f:	29 de                	sub    %ebx,%esi
80107351:	74 2d                	je     80107380 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107353:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107355:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107358:	89 55 0c             	mov    %edx,0xc(%ebp)
8010735b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107361:	57                   	push   %edi
80107362:	ff 75 08             	pushl  0x8(%ebp)
80107365:	e8 56 ff ff ff       	call   801072c0 <uva2ka>
    if(pa0 == 0)
8010736a:	83 c4 10             	add    $0x10,%esp
8010736d:	85 c0                	test   %eax,%eax
8010736f:	75 af                	jne    80107320 <copyout+0x20>
  }
  return 0;
}
80107371:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107379:	5b                   	pop    %ebx
8010737a:	5e                   	pop    %esi
8010737b:	5f                   	pop    %edi
8010737c:	5d                   	pop    %ebp
8010737d:	c3                   	ret    
8010737e:	66 90                	xchg   %ax,%ax
80107380:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107383:	31 c0                	xor    %eax,%eax
}
80107385:	5b                   	pop    %ebx
80107386:	5e                   	pop    %esi
80107387:	5f                   	pop    %edi
80107388:	5d                   	pop    %ebp
80107389:	c3                   	ret    
8010738a:	66 90                	xchg   %ax,%ax
8010738c:	66 90                	xchg   %ax,%ax
8010738e:	66 90                	xchg   %ax,%ax

80107390 <lcg_parkmiller>:

static unsigned random_seed = 1;


unsigned lcg_parkmiller(unsigned *state)
{
80107390:	f3 0f 1e fb          	endbr32 
80107394:	55                   	push   %ebp
          rem*G - div*(N%G) === state*G  (mod N)

        Add N if necessary so that the result is between 1 and N-1.
    */
    unsigned div = *state / (N / G);  /* max : 2,147,483,646 / 44,488 = 48,271 */
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
80107395:	ba 91 13 8f bc       	mov    $0xbc8f1391,%edx
{
8010739a:	89 e5                	mov    %esp,%ebp
8010739c:	56                   	push   %esi
8010739d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801073a0:	53                   	push   %ebx
    unsigned div = *state / (N / G);  /* max : 2,147,483,646 / 44,488 = 48,271 */
801073a1:	8b 19                	mov    (%ecx),%ebx
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
801073a3:	89 d8                	mov    %ebx,%eax
801073a5:	f7 e2                	mul    %edx
801073a7:	c1 ea 0f             	shr    $0xf,%edx
801073aa:	69 c2 c8 ad 00 00    	imul   $0xadc8,%edx,%eax

    unsigned a = rem * G;        /* max : 44,487 * 48,271 = 2,147,431,977 */
    unsigned b = div * (N % G);  /* max : 48,271 * 3,399 = 164,073,129 */
801073b0:	69 d2 47 0d 00 00    	imul   $0xd47,%edx,%edx
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
801073b6:	29 c3                	sub    %eax,%ebx
    unsigned a = rem * G;        /* max : 44,487 * 48,271 = 2,147,431,977 */
801073b8:	69 db 8f bc 00 00    	imul   $0xbc8f,%ebx,%ebx

    return *state = (a > b) ? (a - b) : (a + (N - b));
801073be:	89 de                	mov    %ebx,%esi
801073c0:	8d 83 ff ff ff 7f    	lea    0x7fffffff(%ebx),%eax
801073c6:	29 d6                	sub    %edx,%esi
801073c8:	29 d0                	sub    %edx,%eax
801073ca:	39 d3                	cmp    %edx,%ebx
801073cc:	0f 47 c6             	cmova  %esi,%eax
801073cf:	89 01                	mov    %eax,(%ecx)
}
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5d                   	pop    %ebp
801073d4:	c3                   	ret    
801073d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801073e0 <next_random>:

unsigned next_random() {
801073e0:	f3 0f 1e fb          	endbr32 
    unsigned div = *state / (N / G);  /* max : 2,147,483,646 / 44,488 = 48,271 */
801073e4:	8b 0d 60 a4 10 80    	mov    0x8010a460,%ecx
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
801073ea:	ba 91 13 8f bc       	mov    $0xbc8f1391,%edx
unsigned next_random() {
801073ef:	55                   	push   %ebp
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
801073f0:	89 c8                	mov    %ecx,%eax
801073f2:	f7 e2                	mul    %edx
unsigned next_random() {
801073f4:	89 e5                	mov    %esp,%ebp
801073f6:	53                   	push   %ebx
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
801073f7:	c1 ea 0f             	shr    $0xf,%edx
801073fa:	69 c2 c8 ad 00 00    	imul   $0xadc8,%edx,%eax
    unsigned b = div * (N % G);  /* max : 48,271 * 3,399 = 164,073,129 */
80107400:	69 d2 47 0d 00 00    	imul   $0xd47,%edx,%edx
    unsigned rem = *state % (N / G);  /* max : 2,147,483,646 % 44,488 = 44,487 */
80107406:	29 c1                	sub    %eax,%ecx
    unsigned a = rem * G;        /* max : 44,487 * 48,271 = 2,147,431,977 */
80107408:	69 c9 8f bc 00 00    	imul   $0xbc8f,%ecx,%ecx
    return *state = (a > b) ? (a - b) : (a + (N - b));
8010740e:	89 cb                	mov    %ecx,%ebx
80107410:	8d 81 ff ff ff 7f    	lea    0x7fffffff(%ecx),%eax
80107416:	29 d3                	sub    %edx,%ebx
80107418:	29 d0                	sub    %edx,%eax
8010741a:	39 d1                	cmp    %edx,%ecx
8010741c:	0f 47 c3             	cmova  %ebx,%eax
    return lcg_parkmiller(&random_seed);
}
8010741f:	5b                   	pop    %ebx
80107420:	5d                   	pop    %ebp
    return *state = (a > b) ? (a - b) : (a + (N - b));
80107421:	a3 60 a4 10 80       	mov    %eax,0x8010a460
}
80107426:	c3                   	ret    
