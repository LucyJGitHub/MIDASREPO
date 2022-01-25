     H DEBUG
     H OPTION(*SRCSTMT : *NODEBUGIO)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*    *  CRTDTAARA  DTAARA(QTEMP/FEEDER) TYPE(*CHAR) LEN(64)          *
      *****************************************************************
      *                                                               *
      *  Meridian Replication                                         *
      *                                                               *
      *  RPFEEDER  - Journal Feeder                                   *
      *                                                               *
      *  Function:  This module receives entries from the journal     *
      *             and forwards them to the Environment Feeder       *
      *             MQ queue.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. MD058809           Date 16Dec21               *
      *  Prev Amend No. SFDC01648961/PMS-9791    28Jan16              *
      *                 PMS-8870            Date 03Aug15              *
      *                 582747 Supportforce Date 11Oct11              *
      *                 477879 Supportforce Date 22Nov10              *
      *                 128748 Supportforce Date 13Sep06              *
      *                 126090 Supportforce Date 08Sep06              *
      *                 001077 Bugzilla    Date 16Sep06               *
      *                 000902 Bugzilla    Date 27Apr06               *
      *                 000820 (Bugzilla)  Date 28Mar06               *
      *                 CRP026  *CREATE    Date 18Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058809 - After installation of MQ9 compatibility patch and *
      *             restart of the Meridian Replication subsystem     *
      *             REPMIDASPT, the job MPT1PBSIN ended in MSGW.      *
      *  SFDC01648961/PMS-9791 -                                      *
      *             If two Replication systems are pointed at the     *
      *             same database, then the '01' journal entry sent   *
      *             by ENDRPNFDR causes both feeders to end (as you   *
      *             would expect if you think about it). Change to    *
      *             include the subsystem name as part of the         *
      *             entry-specific data, and only end if the '01'     *
      *             is for the current system.                        *
      *                                                               *
      *  PMS-8870 - Need to increase the maximum size of journal      *
      *             entries buffer again. Wanted to go from 2048      *
      *             to 4096, but doing that blows the limit on the    *
      *             size of a data element (16,773,104 bytes).        *
      *             So I've set the value of BuffArrSizeLg to         *
      *             2342, which is as high as it can go and still     *
      *             let the module compile.                           *
      *                                                               *
      *  582747 - An Equation file now has a record length of over    *
      *           5000, which causes us to have a string index out    *
      *           of range.  Increased the maximum length to 6000.    *
      *           Also had to tweak some other lengths to match.      *
      *                                                               *
      *  477879 - Shut down Feeder only if it was our program that    *
      *           wrote the entry in the journal.                     *
      *  128748 - Add in a 'wait and retry' loop if a queue full      *
      *           condition happens on a write to the Feeder queue.   *
      *  126090 - Shut down Feeder cleanly when 'End of RCVJRNE' code *
      *           is received.                                        *
      *  001077 - Set MQ buffer length for write to Feeder queue to   *
      *           correct length.                                     *
      *  000902 - Increase size of buffer of journal entries from     *
      *           1024 to 2048.                                       *
      *  000820 - When checking for default queue manager test should *
      *           be for blank or *DFT.                               *
      *           Correct message for default queue manager.          *
      *           Get info from control data area via access object.  *
      *  CRP026 - Feeder rewritten in RPG                             *
      *                                                               *
      *****************************************************************

     FRPFEEDSQNOUF   E           K DISK    USROPN COMMIT
      * Last Journal Sequence Number read control file (*SECURE mode)

     FX440LF    iF   E           K DISK    USROPN
      * Cross-reference LF keyed on Feeder Sequence
      *  and Local System (Unit), Remote System (Product)

     FX110LF    iF   E           K DISK    USROPN
      * Remote System (Product) LF keyed on Remote System (Product) name

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **  Declare MQI structures needed
      *      MQI Constants & Prototypes
     D/COPY QMQM/QRPGLESRC,CMQG

      *      Object Descriptor
     D MQOD            DS
     D/COPY QMQM/QRPGLESRC,CMQODG

      *      Message Descriptor
     D MQMD            DS
     D/COPY QMQM/QRPGLESRC,CMQMDR

      *      Put message options
     D MQPMO           DS
     D*COPY*QMQM/QRPGLESRC,CMQPMOR*** The R version didn't match the
      * length specified in the associated prototype for MQPUT.
     D/COPY QMQM/QRPGLESRC,CMQPMOG

     D MQGMO           DS
      ** Get message options
     D/COPY QMQM/QRPGLESRC,CMQGMOG

      * Prototype for Replication logging procedures
     D/COPY RPCPYSRC,LOG_WRITE

      * Prototype for Back Office Interface procedures
     D/COPY RPCPYSRC,BOIF_PR

     D RPFDRSETMQ      PR
      * Prototype for routine to set MQ queue attributes
     D  MQQName                      48A
     D  MQMgrName                    48A
     D  FeederMode                    7A
                                                                                128748
      * Prototype for delay function                                            128748
     D/COPY RPCPYSRC,DLY_PR                                                     128748
                                                                                128748
      * Prototype for MQINQ wrapper                                             128748
     D/COPY RPCPYSRC,MQINQWRAP                                                  128748

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      ** +----------------------------------------------+
      ** ¦ Procedure prototype and procedure interface. ¦
      ** ¦ In global D specs these refer to main        ¦
      ** ¦  routine, replacing *entry plist.            ¦
      ** +----------------------------------------------+

     D RPFEEDER        PR
     D  JnlEntReceived...
     D************                 5149A                                        582747
     D                             6159A                                        582747
     D  JEntryInfo                    3A

     D RPFEEDER        PI
     D  JnlEntReceived...
     D************                 5149A                                        582747
     D                             6159A                                        582747
     D  JEntryInfo                    3A

      ** Prototype for external program (there's an ILE way to do this,
      ** but life's too short).
     D GetSbsName      PR                  ExtPgm('KMDICI')
     D  WhatToGet                     8A   const
     D  CurrentSubsystem...
     D                               10A

      ** +--------------------------------------+
      ** ¦ Program control information          ¦
      ** +--------------------------------------+
                                                                                000820
      ** This information should be obtained from the control                   000820
      ** data area via access object                                            000820
     D*RepnCtlDA*****E DS                  extname(RPBOIFDADC)                  000820
      ***Replication*control data arae                                          000820
     D***************                      dtaara(RPBOIFDA)                     000820
     D**FeederMode***                      overlay(RFFDRMODE) like(RFFDRMODE)   000820
     D**MQSeriesQMName...                                                       000820
     D***************                      overlay(RFMQMNAME) like(RFMQMNAME)   000820
                                                                                000820
     D FeederMode      S              7A                                        000820
     D MQSeriesQMName  S             48A                                        000820
                                                                                000820
     D MQMNameKey      S             10A   inz('MQMNAME   ')                    000820
     D FeederModeKey   S             10A   inz('FEEDERMODE')                    000820
     D DlyTimeKey      S             10A   inz('DLYTIME   ')                    128748
     D NumRptsKey      S             10A   inz('NOOFRPTS  ')                    128748
     D BOIF99Data      S             64A                                        000820
     D BOIF99Len       S              2P 0                                      000820
      ** Keys passed to & values received from RPBOIF99                         000820

     D FdrInfoDA       DS                  dtaara(FEEDERINF)
      ** QTEMP data area that contains this job's Feeder Sequence number
     D  FdrSeqNbr                     1A
     D  Mnemonic                      3A
     D  StartingJrnSeqNbr...
     D                               10A
     D  Filler                       50A

     D LastSeqNbrReadDAName...
      ** Name of data area in which to store Last journal Sequence Number read
     D                 S             10A

     D LastSeqNbrReadDA...
     D                 DS                  dtaara(*VAR : LastSeqNbrReadDAName)
     D  LastSeqNbrRead...
     D                               10A

      ** +---------------------------------------------+
      ** ¦ Journal entries                             ¦
      ** +---------------------------------------------+

     D JournalEntryIn  DS                  qualified
      ** Journal Entry received as a parameter
     D  JEntLen                       5S 0
     D  JSeqNum                      10
     D  JCode                         1
     D  JEntType                      2
     D  JTimestamp                   26
     D  JJobName                     10
     D  JJobUserName                 10
     D  JJobNumber                    6
     D  JProgramName                 10
     D  JObjectName                  10
     D  JObjectLib                   10
     D  JMemberName                  10
     D  JCountRRN                    10
     D  JFlag                         1
     D  JCmtCycID                    10S 0
     D  JUserProfile                 10
     D  JSystemName                   8
     D  JNbrNullValueInds...
     D                                5S 0
     D  JEntSpecDataLen...
     D                                5S 0
     D**JEntSpecData***            5000                                         582747
     D  JEntSpecData               6000                                         582747

     D JnlEntWrk       DS                  likeds(JournalEntryIn)
      ** Journal Entry data structure - common point for entry to be
      **    reformatted and sent

      ** +---------------------------------------------+
      ** ¦ Entry to write to Feeder Queue              ¦
      ** +---------------------------------------------+

     D FeederQEntry    DS
     D  FQEntLen                     10I 0
     D  FQCountI                      5I 0
      ** 10I 0 occupies 4 bytes and 5I 0 occupies 2 bytes
     D  FQDS_Mnemonic                 2
     D  FQCmtCycID                   10S 0
     D  FQEntType                     2
     D  FQTableName                  18
     D  FQNull_Flag                   1
     D  FQEntSpecData                      like(JournalEntryIn.JEntSpecData)

      ** +---------------------------------------------+
      ** ¦ MQSeries Queue name(s) & Connection Handles ¦
      ** +---------------------------------------------+

     D TgtQArrSize     C                   const(100)
     D TgtQName        S                   like(ODON)
     D AddTgtQNameToArr...
     D                 S              5A
     D TgtQNameArr     S                   like(TgtQName) dim(TgtQArrSize)
     D TgtQConHdlArr   S             10I 0 dim(TgtQArrSize)
     D TgtQNameArrIdx  S              3P 0
     D TgtQNameArrSchIdx...
     D                 S                   like(TgtQNameArrIdx)
     D TgtQNameArrIdxMax...
     D                 S              3P 0
      * Target (Feeders) Queue names, etc - may be many

     D BufferQName     S                   like(ODON)
      * Buffer Queue name

     D QNameToUse      S                   like(ODON)
     D QNameToUseType  S             10A
      * MQ Queue name & type (Buffer / Target) passed to Put SRs

      ** +---------------------------------------------+
      ** ¦ Fields needed by MQ calls                   ¦
      ** +---------------------------------------------+

     D QMNAME          S             48A
      * Queue Manager name
     D HCONN           S             10I 0
      * Queue Manager Connection Handle
     D OPTS            S             10I 0
      * Options
     D HOBJ            S             10I 0
     D HOBJBUFQ        S             10I 0
      * Object handles
     D CMPCOD          S             10I 0
      * Completion Code
     D REASON          S             10I 0
      * Reason Code
     D MQBUFLEN        S             10I 0
      * Length of data in the passed buffer
     D DATLEN          S             10I 0
      * Length of data received on an MQGET

     D PMSYPToUse      S              1  0
      * Syncpointing (Yes / No) to use depending on mode *SECURE / *FAST

      ** +---------------------------------------------+
      ** ¦ Miscellaneous                               ¦
      ** +---------------------------------------------+

     D DataBlockToWrite...
     D                 S          +1000    like(JnlEntReceived)
      ** Data block to write, to buffer (MQ or Array) or Target MQ

     D DataBlockToWriteLen...
     D                 S              5P 0
      ** Length of Data block to write, used in MQ call

      ** +---------------------------------------------+                        128748
      ** ¦ Fields used by queue full delay process     ¦                        128748
      ** +---------------------------------------------+                        128748
                                                                                128748
     D DelayTimeAlpha  S              5A                                        128748
     D NumRepeatsAlpha...                                                       128748
     D                 S              5A
     D QFullDelayTime  S             10I 0                                      128748
     D QFullNumRepeats...                                                       128748
     D                 S             10I 0                                      128748
      ** Amount of time to delay and number of times in succession to delay     128748
      **  Alpha version retrieved and numeric version for processing.           128748
     D ContinueWriteLoop...                                                     128748
     D                 S              5A                                        128748
     D NumberTimesDelayed...                                                    128748
     D                 S             10I 0                                      128748
      ** Loop control boolean & count of delays                                 128748
     D WriteQueueFullMsg...                                                     128748
     D                 S              5A                                        128748
      ** Wait limits exceeded so put an appropriate message in the log file     128748
                                                                                128748
      ** +---------------------------------------------+                        128748
      ** ¦ Fields needed by MQINQ wrapper procedure    ¦                        128748
      ** +---------------------------------------------+                        128748
                                                                                128748
     D MQIAttrWanted   S             10I 0                                      128748
     D MQIAttrValue    S             64A                                        128748
      ** What attribute is wanted and the value returned                        128748
     D MQIRetCode      S            128A                                        128748
      ** Return code from procedure                                             128748

      ** +---------------------------------------------+
      ** ¦ Fields used by buffer process               ¦
      ** +---------------------------------------------+

     D BufData         S          10000
      ** Data written to / read from buffer
     D BufQueueKey     S             24A
      ** Buffer queue key
      **  This is 24 long as when an MQ buffer is used it is placed in a 24 long field.
     D BufQuKeyCCID    S                   like(LastComCycID)
      ** Buffer queue key - CC ID
     D BufQuKeySeqNum  S             10P 0
      ** Buffer queue key - sequence number

     D BufQuKeyCCIDAlp...
     D                 S             10A
      ** Buffer queue key - CC ID - alpha version

     D NbrPendMsgs     S              9P 0
      ** Count of outstanding messages on Buffer Queue

     D LastComCycID    S             10S 0
      ** Last commitment cycle id
      ** - used to control reset of Sequence number of message within group

     D UpdateControlFile...
     D                 S              5A   inz('false')
      ** Flag to suppress update of the control file
      **  if unrelated CM/RB entry has been read

     D Goon            S              5A
      ** Loop control flag when getting data back from buffer

     D BuffArrSizeSm   C                   const(256)
     D*BuffArrSizeLg***C                   const(1024)                          000902
     D BuffArrSizeLg   C                   const(2342)
      ** Number of elements in buffer arrays

     D BuffCCIDArr     S                   dim(BuffArrSizeSm) like(LastComCycID)
      ** Buffered CC IDs array - one element per CC ID
     D BuffSeqNbrArr   S                   dim(BuffArrSizeSm) inz(0)
     D                                     like(BufQuKeySeqNum)
      ** Number of entries already stored per CC ID - one element per CC ID
      ** NB This count is only used to set the correct sequence number when
      **  data is being stored, necessary when data from multiple CCs is
      **  interleaved.  The count is not decremented when data is retrieved.
     D BufferCCIDIdx   S              9P 0
      ** Buffer arrays index

     D DataStringArr   S                   dim(BuffArrSizeLg)
     D                                     like(DataBlockToWrite)
      ** Buffer array - data
     D BufferKeyArr    S                   dim(BuffArrSizeLg) like(BufQueueKey)
      ** Buffer array - keys (commitment cycle id / sequence number)
     D BufferIndex     S              9P 0
      ** Buffer arrays index
     D BufferIndexMax  S              9P 0
      ** Highest value of BufferIndex - used to improve performance in Get SR

     D PrvBufferIndex  S                   like(BufferIndex)
     D PrvBufferKey    S                   like(BufQueueKey) inz('ZZZZZZZZZZ')
      ** Array index & key value from previous run of Get SR - to improve performance
      **   PrvBufferKey is initialised to prevent errors at first usage

     D WhatToGet       C                   'SBSNAME '
     D CurrentSubsystem...
     D                 S             10A
     D SubsystemName   S                   like(CurrentSubsystem)

      ** +--------------------------------------+
      ** ¦ Error handling                       ¦
      ** +--------------------------------------+

     D IHaveBeenHereBefore...
      * Flag to make sure ErrorSR does not loop
     D                 S              1A   inz('N')

     D Here            S             64A
      ** Location in program where error was detected - internal value

     D RPFeederErr     DS           256    dtaara(RPFdrErr)
      ** Location in program where error was detected - external value
     D  ErrorLocation                      like(Here)

     D SRSTack         S             64    dim(100)
     D SRIdx           S              3P 0 inz(0)
     D* Subroutine stack

      ** Data to write to X6PF
     D ProcessForLog   S             25A   inz('RPFEEDER')
     D StringForLog    S           1024A

      ** Array of files where entries received with Null Capable Flags,
      **  this is used so that a warning error is only written once per file
      ** 300 files are catered for as that is the number in the module
      **  that builds the RCVJRNE command
     D NCFArrMax       C                   const(300)
     D NullCapableFilesArr...
     D                 S             10    dim(NCFArrMax)
     D NCFArrIdx       S              3P 0 inz(0)

     ******************************************************************
      /free

        // If program is being forcibly ended try to shut down as
        //  cleanly as possible
        // Code has been moved to a subroutine to make it more cleanly          //128748
        //  executable elsewhere                                                //128748
        //******                                                                //128748
        //*if*%shtdn = '1';                                                     //128748
        //****exsr EndFunction;                                                 //128748
        //****return;                                                           //128748
        //*endif;                                                               //128748
        exsr CheckAndExecuteShutdown;                                           //128748

        // If the 'End of RCVJRNE' code is received shut down cleanly.          //126090
        //  A code of '3' means no more entries can be passed, because          //126090
        //  the journal receiver that was attached when the command             //126090
        //  started is no longer attached.                                      //126090
        if %subst( JEntryInfo : 1 : 1) = '3';                                   //126090
           exsr EndFunction;                                                    //126090
           return;                                                              //126090
        endif;                                                                  //126090

        // Ignore everything other than data calls
        if %subst( JEntryInfo : 1 : 1) <> '1';
           return;
        endif;

        // Split up the incoming journal entry
        //  JournalEntryIn is a DS and JnlEntReceived the input data
        JournalEntryIn = JnlEntReceived;

        // An '01' entry means to exit - as long as it applies
        // to this subsystem.
        // Force update of control file / data area to prevent
        //    this entry being re-read
        SubsystemName = %subst(JournalEntryIn.JEntSpecData :
                               1 : JournalEntryIn.JEntSpecDataLen);
        if JournalEntryIn.JEntType = '01'
         AND %trim(JournalEntryIn.JProgramName) = 'KMDSFC'                    //477879
         AND %trim(SubsystemName) = %trim(CurrentSubsystem);
           exsr EndOfEntry;
           exsr EndFunction;
           return;
        endif;

        // Journal entries not under commitment control are simply forwarded
        // NB The RCVJRNE command only includes relevant journal entries, so
        //  there is no need to test the Entry Type here
        if JournalEntryIn.JCmtCycID = 0;
           exsr CheckNullCapable;
           exsr SimpleForward;
           exsr EndOfEntry;
           return;
        endif;

        // To get to here, journal entries must be under commitment control

        // Any data change entries (Insert / Amend / Delete) need to be
        // stored in a buffer until the associated Commit / Rollback
        // entry is read.
        if    JournalEntryIn.JEntType = 'PT' OR JournalEntryIn.JEntType = 'PX'
           OR JournalEntryIn.JEntType = 'UB' OR JournalEntryIn.JEntType = 'UP'
           OR JournalEntryIn.JEntType = 'DL';

           exsr CheckNullCapable;
           exsr StoreChanges;
           exsr EndOfEntry;
           return;
        endif;

        // If it is a Commit / Rollback entry, read the associated entries
        // from the buffer.
        // If it is a Commit entry forward the entries read.
        // If it is a Rollback do nothing more to discard the entries read.

        if    JournalEntryIn.JEntType = 'CM'
           OR JournalEntryIn.JEntType = 'RB';

           // If no entries are read from the buffer this is a
           //  CM/RB entry for data entries that have not been processed
           //  so there is no need to update the control file and flag will
           //  be set to false in SR
           UpdateControlFile = 'true';

           exsr ProcessCommitRollback;

           if UpdateControlFile = 'true';
              exsr EndOfEntry;
           endif;
           return;
        endif;

        // If it is some sort of data entry but none of
        //  Insert / Amend / Delete or Commit / Rollback entry,
        //  just ignore it.
        return;

       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr StoreChanges;

        // Process Insert / Amend / Delete entries that are to be stored
        //  until the associated Commit / Rollback entry is read.

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'StoreChanges';

        // Set the buffer queue key
        BufQuKeyCCID = JournalEntryIn.JCmtCycID;
        // BufQueueKey = %char( JournalEntryIn.JCmtCycID);
        DataBlockToWrite = JnlEntReceived;

        // Store using the appropriate mechanism, Arrays or MQ queue
        if FeederMode = '*FAST';
           exsr PutMsgArrSR;
        else;
           // FeederMode is *SECURE
           QNameToUseType = 'Buffer';
           QNameToUse     = BufferQName;
           HOBJ = HOBJBUFQ;
           DataBlockToWriteLen = JournalEntryIn.JEntLen;
           exsr PutMsgMQSR;

           // Keep count of how many entries have been stored
           NbrPendMsgs = NbrPendMsgs + 1;
        endif;

        // Log message of journal entry stored
        StringForLog = 'Data stored for journal entry number ' +
                 JournalEntryIn.JSeqNum + ' of type ' +
                 JournalEntryIn.JEntType +
                 ' for committment cycle id ' +
                 %char( JournalEntryIn.JCmtCycID) +
                 ' at ' + %char(%timestamp());
        callp DebugOut(ProcessForLog : StringForLog);

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr PutMsgArrSR;

        // Buffer data in arrays for performance

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'PutMsgArrSR';

        // If the CC ID has changed then ...
        if BufQuKeyCCID <> LastComCycID;
           // Look for an element showing data already stored for this CC ID
           for BufferCCIDIdx = 1 by 1 to BuffArrSizeSm;
              if BuffCCIDArr( BufferCCIDIdx) = BufQuKeyCCID;
                 leave;
              endif;
           endfor;

           // If a matching element was not found, use the first empty one
           if    BufferCCIDIdx > BuffArrSizeSm
              OR BuffCCIDArr( BufferCCIDIdx) <> BufQuKeyCCID;
              for BufferCCIDIdx = 1 by 1 to BuffArrSizeSm;
                 if BuffCCIDArr( BufferCCIDIdx) = 0;
                    leave;
                 endif;
              endfor;

              BuffCCIDArr( BufferCCIDIdx) = BufQuKeyCCID;
              BuffSeqNbrArr( BufferCCIDIdx) = 0;
           endif;

           // Convert numeric CC ID using %editc() as %char() strips leading 0s
           BufQuKeyCCIDAlp = %editc( BufQuKeyCCID : 'X');

           // Store the CC ID to speed up the next run
           LastComCycID = BufQuKeyCCID;
        endif;

        // If the CC ID has changed then the Alpha CC ID and the array
        //  index will have just been set up and the count will be zero
        // If the CC ID has not changed then the Alpha CC ID and
        //  the array index will remain from the previous run

        // So, increment the associated count ...
        BuffSeqNbrArr( BufferCCIDIdx) = BuffSeqNbrArr( BufferCCIDIdx) + 1;

        // ... and build the key from the Alpha CC ID and the sequence number
        BufQueueKey = BufQuKeyCCIDAlp +
                         %editc( BuffSeqNbrArr( BufferCCIDIdx) : 'X');

        // Find the first available data array element
        for BufferIndex = 1 by 1 to BuffArrSizeLg;
           if BufferKeyArr( BufferIndex) = *blank;
              leave;
           endif;
        endfor;

        // If no available data array element was found then end in error.
        if BufferIndex > BuffArrSizeLg;
           StringForLog = 'Buffer array is full - see dump '+
                    %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'Buffer index over limit';
           exsr ErrorSR;
        endif;

        // Store the data in the array element found and the key in the
        //   associated keys array element
        DataStringArr( BufferIndex) = DataBlockToWrite;
        BufferKeyArr( BufferIndex)  = BufQueueKey;

        // Store the highest index value for this run, to improve
        //   performance in the corresponding Get SR
        if BufferIndex > BufferIndexMax;
           BufferIndexMax = BufferIndex;
        endif;

        // Log details of journal entry stored
        StringForLog = 'Data stored in buffer array element ' +
                %char( BufferIndex) + ' of value ' + DataBlockToWrite;
        callp DebugOut(ProcessForLog : StringForLog);

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr PutMsgMQSR;

        // Write a message to an MQ queue
        // If this is the Buffer queue then this is done for security

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'PutMsgMQSR';

        // The amount of data to be put will have been set up earlier
        //  - for the target queue in the formatting SR
        //  - for the buffer queue in the StoreChanges SR
        //  for performance reasons, as %trim() is slow.
        MQBUFLEN = DataBlockToWriteLen;

        // Remove this block as it simply wrong and causes a Server problem     //001077
        //*If*writing*to*the*target*queue*(where*the*data*may*reside for        //001077
        //**a*while)*AND*running*in**SECURE*mode,*set*the*amount of data to be p//001077
        //**to*be*put*as*the*actual*value**********************                 //001077
        //*if*QNameToUseType = 'Target' AND FeederMode = '*SECURE';             //001077
        //****MQBUFLEN = %len(%trim( DataBlockToWrite));                        //001077
        //*endif;***                                                            //001077

        // Message options: Format name of data is String,
        //         Correlation identifier is Group & Sequence or None
        //  MDFMT & MDCID are subfields of the supplied data structure MQMD
        MDFMT = FMSTR;
        MDCID = CINONE;
        if QNameToUseType = 'Buffer';
           MDCID = %char( BufQuKeyCCID);
        endif;

        // Put options:
        // - PMNMID (Generate a new message id)
        // - PMSYPToUse (Syncpointing on/off (PMSYP/PMNSYP))
        //  PMOPT is a subfield of the supplied data structure MQPMO
        PMOPT = PMNMID + PMSYPToUse;

        // HCONN is the Connection Handle for the Queue Manager -
        //  obtained earlier
        // HOBJ is the Connection Handle for the Queue
        // MQBUFLEN is the amount of data to be put
        // DataBlockToWrite contains the data that is to be put -
        //  passed as a pointer
        // CMPCOD is the Completion Code and REASON is the Reason Code
        //*callp*MQPUT(HCONN*:*HOBJ : MQMD : MQPMO : MQBUFLEN :                 //128748
        //*****************%addr( DataBlockToWrite) : CMPCOD : REASON);         //128748
                                                                                //128748
        // For Target (i.e. Feeder) queue write perform processing in a         //128748
        //  loop to cater for queue full condition with a delay and             //128748
        //  retry approach.  This is not necessary for the Buffer queue         //128748
        //  or for other error conditions.                                      //128748
        ContinueWriteLoop = 'true';                                             //128748
        NumberTimesDelayed = 0;                                                 //128748
        WriteQueueFullMsg = 'false';                                            //128748
        dow ContinueWriteLoop = 'true';                                         //128748
           callp MQPUT(HCONN : HOBJ : MQMD : MQPMO : MQBUFLEN :                 //128748
                           %addr( DataBlockToWrite) : CMPCOD : REASON);         //128748
           if REASON = RC2053 AND QNameToUseType = 'Target';                    //128748
              NumberTimesDelayed = NumberTimesDelayed + 1;                      //128748
              if NumberTimesDelayed > QFullNumRepeats;                          //128748
                 ContinueWriteLoop = 'false';                                   //128748
                 WriteQueueFullMsg = 'true';                                    //128748
              else;                                                             //128748
                 StringForLog = 'About to delay time number ' +                 //128748
                          %char( NumberTimesDelayed) + ' because queue ' +      //128748
                          %trim( QNameToUse) + ' is full, at ' +                //128748
                          %char(%timestamp());                                  //128748
                 callp TraceOut(ProcessForLog : StringForLog);                  //128748
                 callp RPDELAY( QFullDelayTime);                                //128748
                 exsr CheckAndExecuteShutdown;                                  //128748
              endif;                                                            //128748
           else;                                                                //128748
              ContinueWriteLoop = 'false';                                      //128748
           endif;                                                               //128748
        enddo;                                                                  //128748

        // Error processing - when the problem is the Target queue was full     //128748
        //  too many times in a row.                                            //128748
        //  Output a suitable message and a message with the queue's max depth  //128748
        if WriteQueueFullMsg = 'true';                                          //128748
           StringForLog = 'Error writing to queue ' + %trim( QNameToUse) +      //128748
                    ': retried ' + %char( QFullNumRepeats) +                    //128748
                    ' times, waiting ' + %char( QFullDelayTime) +               //128748
                    ' seconds each time, at ' + %char(%timestamp());            //128748
           callp ErrorOut(ProcessForLog : StringForLog);                        //128748
                                                                                //128748
           MQIAttrWanted = IAMDEP;  // Max number of messages allowed on queue  //128748
           callp RtvQAttr ( HCONN : *OMIT : QNameToUse : MQIAttrWanted :        //128748
                            MQIAttrValue : MQIRetCode);                         //128748
           if MQIRetCode = *BLANK;                                              //128748
              StringForLog = 'Queue ' + %trim( QNameToUse) + ' has a maximum' + //128748
                       ' depth of ' + %trim( MQIAttrValue) + ' messages, at ' + //128748
                       %char(%timestamp());                                     //128748
              callp ErrorOut(ProcessForLog : StringForLog);                     //128748
           endif;                                                               //128748
                                                                                //128748
           Here = 'PutMsgSR';                                                   //128748
           exsr ErrorSR;                                                        //128748
        endif;                                                                  //128748
                                                                                //128748
        //*Error*processing***                                                  //128748
        // Error processing - All other cases                                   //128748
        if REASON <> RCNONE;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when put message to Queue ' +
                    %trim( QNameToUse) + ' at ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'PutMsgSR';
           exsr ErrorSR;
        endif;

        // Log details of journal entry stored
        if QNameToUseType = 'Buffer';
           StringForLog = 'Data stored in buffer queue ' +
                   %trim( BufferQName) + ' of value ' + DataBlockToWrite;
           callp DebugOut(ProcessForLog : StringForLog);
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr ProcessCommitRollback;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'ProcessCommitRollback';

        // Log message of Commit / Rollback journal entry received
        StringForLog = 'Journal entry of type ' + JournalEntryIn.JEntType +
                 ' received for committment cycle id ' +
                 %char( JournalEntryIn.JCmtCycID) + ' at ' +
                 %char(%timestamp());
        callp DebugOut(ProcessForLog : StringForLog);

        // Static parameters are now set, so read all matching entries
        //  in a loop until the data is blank.
        // If it is a commit journal entry:
        // - format and output each entry read from the data queue
        // If it is a rollback journal entry:
        // - discard the data read from the data queue

        // Set the buffer queue key as the committment cycle id
        BufQuKeyCCID = JournalEntryIn.JCmtCycID;
        // BufQueueKey = %char( JournalEntryIn.JCmtCycID);

        // Also set a value for the sequence number within the committment cycle id
        // For *FAST mode this is used to get the right entries
        // For both modes this is used to ignore unrelated CM/RB entries
        BufQuKeySeqNum = 0;

        Goon = 'true';
        dow  Goon = 'true';
           BufData = *BLANK;

           // Increment Sequence number of message within group
           BufQuKeySeqNum = BufQuKeySeqNum + 1;

           if FeederMode = '*FAST';
              exsr GetMsgArrSR;
           else;
              exsr GetMsgMQSR;
           endif;

           // If no data was retrieved then exit this SR
           if BufData = *BLANK;

              // If this is the first get, then this must be an unrelated CM/RB entry
              if BufQuKeySeqNum = 1;
                 StringForLog = 'Unrelated CM entry being ignored';
                 callp DebugOut(ProcessForLog : StringForLog);

                 // For *SECURE mode supress updating of the control file
                 if FeederMode = '*SECURE';
                    UpdateControlFile = 'false';
                 endif;
              endif;

              // If this is not the first get and in *FAST mode, reset the
              //  relevant CC ID and associated 'entries stored' array elements.
              if BufQuKeySeqNum <> 1 AND FeederMode = '*FAST';
                 // Look for the matching CC ID element
                 for BufferCCIDIdx = 1 by 1 to BuffArrSizeSm;
                    if BuffCCIDArr( BufferCCIDIdx) = LastComCycID;
                       reset BuffCCIDArr( BufferCCIDIdx);
                       reset BuffSeqNbrArr( BufferCCIDIdx);
                       leave;
                    endif;
                 endfor;
              endif;

              Goon = 'false';
              leave;
           endif;  // End of 'if BufData = *BLANK;'

           // Data was retrieved so format it and write it out

           // Store the current version of the commitment ID
           // as the last one, for checking next time through
           LastComCycID = BufQuKeyCCID;

           // Keep count of how many entries are still stored
           if FeederMode = '*SECURE';
              NbrPendMsgs = NbrPendMsgs - 1;
           endif;

           // JnlEntWrk is a DS (the same as JournalEntryIn) and is a common
           //    place where data to be output is placed for processing
           JnlEntWrk = %subst( BufData : 1);

           if JournalEntryIn.JEntType = 'CM';
        //****StringForLog*=*'Wrote message for journal entry number ' +        //128748
              StringForLog='About to write message for journal entry number '+
              JnlEntWrk.JSeqNum + ' of type ' + JnlEntWrk.JEntType +
              ' which was under commitment control' +
              ' at ' + %char(%timestamp());
              callp DebugOut(ProcessForLog : StringForLog);
              exsr FormatOP;
              DataBlockToWrite = FeederQEntry;

              // Write data to all Target Queue(s)
              for TgtQNameArrIdx = 1 by 1 to TgtQNameArrIdxMax;
                 QNameToUseType = 'Target';
                 QNameToUse = TgtQNameArr( TgtQNameArrIdx);
                 HOBJ = TgtQConHdlArr( TgtQNameArrIdx);
                 exsr PutMsgMQSR;
              endfor;
           else;
              // Type is RB
        //****StringForLog*=*'Discarded message for journal entry number ' +    //128748
              StringForLog='About to discard message for journal entry number '+
              JnlEntWrk.JSeqNum + ' of type ' + JnlEntWrk.JEntType +
              ' which was under commitment control' +
              ' at ' + %char(%timestamp());
              callp DebugOut(ProcessForLog : StringForLog);
           endif;

        enddo;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr GetMsgArrSR;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'GetMsgArrSR';

        // Build the key from the CCID and the sequence number
        BufQueueKey = %editc( BufQuKeyCCID : 'X') +
                         %editc( BufQuKeySeqNum : 'X');

        // Search through the keys array until a match is found, then
        //   - copy the data element to a work field
        //   - blank out the data & key elements so they don't get read again
        //   - store the key value & array index to speed up the next
        //     access for this key
        for BufferIndex = 1 by 1 to BufferIndexMax;
           if BufferKeyArr( BufferIndex) = BufQueueKey;
              BufData = DataStringArr( BufferIndex);

              DataStringArr( BufferIndex) = *blank;
              BufferKeyArr( BufferIndex)  = *blank;

              // Log details of journal entry retrieved
              StringForLog = 'Data retrieved from array element ' +
                      %char( BufferIndex) + ' of value ' + BufData;
              callp DebugOut(ProcessForLog : StringForLog);

              leave;
           endif;
        endfor;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr GetMsgMQSR;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'GetMsgMQSR';

        // Get a message from the Buffer MQ queue
        //    Unlike the associated Put SR, this one never
        //    uses the Target queue(s)

        // Message options: Message is a member of a group
        //         Correlation identifier is Group & Sequence
        //  MDMFL & MDCID are subfields of the supplied data structure MQMD

        // Set the key as just the CC ID
        MDCID =  %char( BufQuKeyCCID);

        // Get options:
        // - GMSYP (Syncpointing on)
        // - GMNWT (Return immediately if no suitable message)
        //  GMOPT is a subfield of the supplied data structure MQGMO
        GMOPT = GMSYP + GMNWT;

        // - MOCORI (Retrieve message with specified correlation identifier)
        //  GMMO is a subfield of the supplied data structure MQGMO
        GMMO = MOCORI;

        // Set the amount of data to be received
        MQBUFLEN = 10000;

        // HCONN is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // HOBJ is the Connection Handle for the Buffer Queue
        // MQBUFLEN is the amount of data to be got
        // BufData will contain the data received
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQGET(HCONN : HOBJBUFQ : MQMD : MQGMO : MQBUFLEN :
                           %addr( BufData) : DATLEN : CMPCOD : REASON);

        // Error processing MQRC_NO_MSG_AVAILABLE
        //  RC2033 is MQRC_NO_MSG_AVAILABLE and means that all messages for
        //   this committment cycle have been processed
        if REASON <> RCNONE AND REASON <> RC2033;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when getting message from Queue ' +
                    BufferQName + ' at ' + %char(%timestamp());
           Here = 'GetMsgMQSR';
           exsr ErrorSR;
        endif;

        // Log details of journal entry retrieved
        if BufData <> *BLANK;
           StringForLog = 'Data retrieved from queue ' + %trim( BufferQName) +
                   ' of value ' + BufData;
           callp DebugOut(ProcessForLog : StringForLog);
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr FormatOP;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'FormatOP';

        // Some output fields have constant values and are set up in *inzsr
        FQEntLen      = %int( JnlEntWrk.JEntSpecDataLen);
        FQCmtCycID    = JnlEntWrk.JCmtCycID;
        FQEntType     = JnlEntWrk.JEntType;
        FQTableName   = JnlEntWrk.JObjectName;
        // If there are any null capable fields in the file there will be a set
        //  of Null Value Indicators at the start of the Entry Specific Data.
        FQEntSpecData = %subst( JnlEntWrk.JEntSpecData :
            1 + JnlEntWrk.JNbrNullValueInds : JnlEntWrk.JEntSpecDataLen);

        // Set MQ message length as length of header fields set up here
        //   and those set up in *inzsr (39) plus the length of the
        //   entry specific data
        DataBlockToWriteLen = 39 + JnlEntWrk.JEntSpecDataLen;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr SimpleForward;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'SimpleForward';

        // Journal entries are not under commitment control so simply forward them

        // JnlEntWrk is a DS (the same as JournalEntryIn) and is a common
        //    place where data to be output is placed for processing
        JnlEntWrk = JnlEntReceived;
        exsr FormatOP;
        DataBlockToWrite = FeederQEntry;

        // Write data to all Target Queue(s)
        for TgtQNameArrIdx = 1 by 1 to TgtQNameArrIdxMax;
           QNameToUseType = 'Target';
           QNameToUse = TgtQNameArr( TgtQNameArrIdx);
           HOBJ = TgtQConHdlArr( TgtQNameArrIdx);
           exsr PutMsgMQSR;
        endfor;

        // Log message of journal entry forwarded w/out commitment control
        StringForLog = 'Wrote message for journal entry number ' +
                JnlEntWrk.JSeqNum + ' of type ' + JnlEntWrk.JEntType +
                 ' which was not under commitment control' +
                 ' at ' + %char(%timestamp());
        callp DebugOut(ProcessForLog : StringForLog);

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr EndOfEntry;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'EndOfEntry';

        // Update the Last Journal Sequence Number read and,
        //    if *SECURE, Count of entries on Buffer Queue
        if FeederMode = '*FAST';

           // Log Last Journal Sequence Number read update about to take place
           StringForLog = 'About to set Last Journal Sequence Number read to ' +
                    JournalEntryIn.JSeqNum + ' in data area ' +
                    %trim( LastSeqNbrReadDAName) + ' at ' + %char(%timestamp());
           callp TraceOut(ProcessForLog : StringForLog);

           in *LOCK LastSeqNbrReadDA;
           LastSeqNbrRead = JournalEntryIn.JSeqNum;
           out LastSeqNbrReadDA;
           // callp RPFDRUPDDA( LastSeqNbrReadDAName : JournalEntryIn.JSeqNum);
        else;

        // FeederMode is *SECURE
           // Log Last Journal Sequence Number read update about to take place
           StringForLog = 'About to set Last Journal Sequence Number read to ' +
                    JournalEntryIn.JSeqNum + ' in file RPFEEDSQNO, record ' +
                    FdrSeqNbr + ' at ' + %char(%timestamp());
           callp TraceOut(ProcessForLog : StringForLog);

           chain(e) FdrSeqNbr RPFEEDSQNO;
           if %error = '1' or not %found;
              StringForLog = 'Error occurred when chaining to file +
                       RPFEEDSQNO with key ' + FdrSeqNbr + ' - see dump '+
                       %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);
              Here = 'chain RPFEEDSQNO';
              exsr ErrorSR;
           endif;

           // Update data and release record.
           RGSEQNUM = %dec( JournalEntryIn.JSeqNum : 10 : 0);
           RGSTRNUM = NbrPendMsgs;

           update(e) RPFDSQNOD0;
           if %error = '1' or not %found;
              StringForLog = 'Error occurred when updating file +
                       RPFEEDSQNO with key ' + FdrSeqNbr + ' - see dump '+
                       %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);
              Here = 'update RPFDSQNOD0';
              exsr ErrorSR;
           endif;

           // Log that we are about to commit
           StringForLog = 'About to commit changes at ' + %char(%timestamp());
           SubsystemName = %subst(JournalEntryIn.JEntSpecData :
                                  1 : JournalEntryIn.JEntSpecDataLen);
           if JournalEntryIn.JEntType = '01'
            AND %trim(SubsystemName) = %trim(CurrentSubsystem)
            AND %trim(JournalEntryIn.JProgramName) = 'KMDSFC';                 //477879
              StringForLog = 'About to commit final changes at ' +
                                        %char(%timestamp());
           endif;
           callp DebugOut(ProcessForLog : StringForLog);

           commit;

        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr CheckNullCapable;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'CheckNullCapable';

        // If the count of Null Capable indicators is non-zero, write out a
        //  warning message but only once per file
        if JournalEntryIn.JNbrNullValueInds > 0;

           // Check for file name being in array
           for NCFArrIdx = 1 by 1 to NCFArrMax;
              if NullCapableFilesArr( NCFArrIdx) = JournalEntryIn.JObjectName;
                 leave;
              endif;
           endfor;

           // If file name was not found - send message and add name
           if NCFArrIdx > NCFArrMax;
              StringForLog = '** WARNING ** Null capapble fields on file ' +
                       %trim( JournalEntryIn.JObjectName) +
                       ', which may cause later problems. ' +
                       ' At ' + %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);

              for NCFArrIdx = 1 by 1 to NCFArrMax;
                 if NullCapableFilesArr( NCFArrIdx) = *BLANK;
                    NullCapableFilesArr( NCFArrIdx) =
                       JournalEntryIn.JObjectName;
                    leave;
                 endif;
              endfor;

           endif;

        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr ConnectToQueueManager;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'ConnectToQueueManager';

        //**//*Set name of queue manager to be connected to                     //000820
        //**if*MQSeriesQMName <> '*DFT';                                        //000820
        //*****QMNAME = MQSeriesQMName;                                         //000820
        //**else;*                                                              //000820
        //*****QMNAME = *BLANK;                                                 //000820
        //**endif;                                                              //000820
        //********                                                              //000820
        //**//*Log name of queue manager to be connected to                     //000820
        //**StringForLog = 'About to connect to Queue Manager ' +               //000820
        //********   %trim( QMNAME) + ' at ' + %char(%timestamp());             //000820
        //**callp*EntryOut(ProcessForLog : StringForLog);                       //000820
                                                                                //000820
        // Log appropriate message depending upon queue manager                 //000820
        // to be connected to.                                                  //000820
        if MQSeriesQMName = '*DFT' OR MQSeriesQMName = *BLANK;                  //000820
           StringForLog = 'About to connect to the default Queue +
                           Manager at ' + %char(%timestamp());                  //000820
           QMNAME = *BLANK;                                                     //000820
        else;                                                                   //000820
           QMNAME = MQSeriesQMName;                                             //000820
           StringForLog = 'About to connect to Queue Manager ' +                //000820
                    %trim( QMNAME) + ' at ' + %char(%timestamp());              //000820
        endif;                                                                  //000820
        callp EntryOut(ProcessForLog : StringForLog);                           //000820

        // HCONN is the returned Connection Handle for the Queue Manager
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQCONN(QMNAME : HCONN : CMPCOD : REASON);

        // Error processing
        if REASON <> RCNONE;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when connecting to Queue Manager ' +
                    QMNAME + ' at ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'Connect';
           exsr ErrorSR;
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr ConnectToTargetQueues;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'ConnectToTargetQueues';

        // Generate Target Queue name(s) by accessing all X4PF records that
        //  specify this Feeder Sequence number and then accessing the
        //  associated X1PF records to get the Meridian Name (Channel Name).
        // Target Queue name is <Meridian-Name>.<Mnemonic>
        open(e) X440LF;
        if %error = '1';
           StringForLog = 'Error occurred when opening file +
                    X440LF - see dump ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'open X440LF';
           exsr ErrorSR;
        endif;
        open(e) X110LF;
        if %error = '1';
           StringForLog = 'Error occurred when opening file +
                    X110LF - see dump ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'open X110LF';
           exsr ErrorSR;
        endif;

        setll(e) FdrSeqNbr X440LF;
        if %error = '1';
           StringForLog = 'Error occurred when setting lower limits +
                    on file X440LF with key of ' + FdrSeqNbr + ' - see dump ' +
                    %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'setll X440LF';
           exsr ErrorSR;
        endif;

        dou %eof(X440LF) = '1';
           reade(e) FdrSeqNbr X440LF;
           if %error = '1';
              StringForLog = 'Error occurred when reading +
                       file X440LF with a key of ' + FdrSeqNbr +
                       ' - see dump ' + %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);
              Here = 'reade X440LF';
              exsr ErrorSR;
           endif;

           if %eof(X440LF) = '1';
              leave;
           endif;

           chain(e) X4PRDN X110LF;
           if %error = '1' or not %found;
              StringForLog = 'Error occurred when chaining file +
                       X110LF  with a key of ' + X4PRDN + ' - see dump ' +
                       %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);
              Here = 'chain X110LF';
              exsr ErrorSR;
           endif;

           TgtQName = %trim(X1CHNL) + '.' + Mnemonic;

        // This will have generated duplicate instances of the same Target Queue
        //  name, if the same data is sent to multiple Remote Computers, so
        //  check for the name already existing and do not add it if it does.
           AddTgtQNameToArr = 'true';
           for TgtQNameArrSchIdx = 1 by 1 to TgtQNameArrIdx;
              if TgtQNameArr( TgtQNameArrSchIdx) = TgtQName;
                 AddTgtQNameToArr = 'false';
              endif;
           endfor;

           if AddTgtQNameToArr = 'true';
              TgtQNameArrIdx = TgtQNameArrIdx + 1;
              TgtQNameArr( TgtQNameArrIdx) = TgtQName;
           endif;
        enddo;

        TgtQNameArrIdxMax = TgtQNameArrIdx;

        close(e) X440LF;
        close(e) X110LF;

        // Make sure that each Target Queue(s) has the correct DFTMSGPST attribute
        for TgtQNameArrIdx = 1 by 1 to TgtQNameArrIdxMax;
           QNameToUse = TgtQNameArr( TgtQNameArrIdx);
           callp RPFDRSETMQ( QNameToUse : MQSeriesQMName : FeederMode);
        endfor;

        // Open all Target Queue(s) and store the associated connection handles
        QNameToUseType = 'Target';
        for TgtQNameArrIdx = 1 by 1 to TgtQNameArrIdxMax;
           QNameToUse = TgtQNameArr( TgtQNameArrIdx);
           exsr OpenQueue;
           TgtQConHdlArr( TgtQNameArrIdx) = HOBJ;
        endfor;

        endsr;

       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr OpenQueue;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'OpenQueue';

        // Set name of queue to be opened.
        //  ODON is a subfield of the supplied data structure MQOD
        ODON = QNameToUse;

        // Open options always include: OUTPUT and FAIL_IF_QUIESCING
        OPTS = OOOUT + OOFIQ;

        // Open options for BufferQ also include: INPUT
        if QNameToUseType = 'Buffer';
           OPTS = OPTS + OOINPQ;
        endif;

        // Log name of queue to be opened
        StringForLog = 'About to open Queue ' +
                 %trim( ODON) + ' at ' + %char(%timestamp());
        callp TraceOut(ProcessForLog : StringForLog);

        // HCONN is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // HOBJ is the returned Connection Handle for the Queue
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQOPEN(HCONN : MQOD : OPTS : HOBJ : CMPCOD : REASON);

        // Error processing
        if REASON <> RCNONE;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when opening to Queue ' +
                    ODON + ' at ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'OpenQueue';
           exsr ErrorSR;
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr CloseQueue;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'CloseQueue';

        // Close options: CONONE (No optional processing to be performed)
        OPTS = CONONE;

        // Log name of queue to be closed
        StringForLog = 'About to close Queue ' +
                 %trim( QNameToUse) + ' at ' + %char(%timestamp());
        callp TraceOut(ProcessForLog : StringForLog);

        // HCONN is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // HOBJ is the Connection Handle for the Queue
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQCLOSE(HCONN : HOBJ : OPTS : CMPCOD : REASON);

        // Error processing
        //  RC2019 is HOBJ_ERROR and probably means the queue was never
        //   opened in the first place
        if REASON <> RCNONE AND REASON <> RC2019;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when closing Queue ' +
                    ODON + ' at ' + %char(%timestamp());
           Here = 'CloseQueue';
           exsr ErrorSR;
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr DisconnectFromQueueManager;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'DisconnectFromQueueManager';

        // Log name of queue manager to be disconnected to
        StringForLog = 'About to disconnect from Queue Manager ' +
                 %trim( QMNAME) + ' at ' + %char(%timestamp());
        callp TraceOut(ProcessForLog : StringForLog);

        // HCONN is the Connection Handle for the Queue Manager
        //  - obtained earlier
        // CMPCOD is the Completion Code and REASON is the Reason Code
        callp MQDISC(HCONN : CMPCOD : REASON);

        // Error processing
        if REASON <> RCNONE;
           StringForLog = 'Reason code  ' + %char( REASON) +
                    ' received when disconnecting from Queue Manager ' +
                    QMNAME + ' at ' + %char(%timestamp());
           Here = 'Disconnect';
           exsr ErrorSR;
        endif;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr ErrorSR;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'ErrorSR';

        // Prevent infinite loops
        if IHaveBeenHereBefore = 'Y';
           return;
        endif;
        IHaveBeenHereBefore = 'Y';

        // Place error location into data area so that calling CL knows
        //    an error occurred.
        in *lock RPFeederErr;
        ErrorLocation = Here;
        out RPFeederErr;

        %subst( JEntryInfo : 1 : 1) = '9';

        dump;

        // Housekeeping
        exsr EndFunction;

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        return;

        endsr;
       // ***************************************************************
      /EJECT
       // ***************************************************************
        begsr EndFunction;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = 'EndFunction';

        // An '01' entry  received - exit
        %subst( JEntryInfo : 1 : 1) = '9';

        StringForLog = 'About to close all Target Queues at ' +
                 %char(%timestamp());
        callp TraceOut(ProcessForLog : StringForLog);

        // Close all Target Queue(s)
        for TgtQNameArrIdx = 1 by 1 to TgtQNameArrIdxMax;

           QNameToUse = TgtQNameArr( TgtQNameArrIdx);
           HOBJ = TgtQConHdlArr( TgtQNameArrIdx);
           exsr CloseQueue;
        endfor;

        // If they were opened, close Last Journal Sequence Number file
        //    and Buffer Queue
        if FeederMode = '*SECURE';
           close(e) RPFEEDSQNO;

           // Log name of queue to be closed
           StringForLog = 'About to close Buffer Queue at ' +
                    %char(%timestamp());
           callp TraceOut(ProcessForLog : StringForLog);

           QNameToUse = BufferQName;
           HOBJ = HOBJBUFQ;
           exsr CloseQueue;
        endif;

        // If count of how many entry have been stored is non-zero log this
        if NbrPendMsgs <> 0;
           StringForLog = 'There are ' + %char( NbrPendMsgs) +
                 ' Journal Entries pending when the Feeder ended ' +
                 %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
        endif;

        exsr DisconnectFromQueueManager;

        *inlr = '1';

        // Send log message to show that program is ending
        StringForLog = 'Replication Feeder ending' +
                 ' at ' + %char(%timestamp());
        callp EntryOut(ProcessForLog : StringForLog);

        // Close log file
        //  The first XxxxxOut() routine called will have implicitly opened the
        //  log file.  When the Feeder is running in batch leaving a lock will
        //  not matter, but when it is run interactively (e.g. when debugging)
        //  it can cause a problem.
        callp CloseLog();

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;
       // ***************************************************************       //128748
      /EJECT                                                                    //128748
       // ***************************************************************       //128748
        begsr CheckAndExecuteShutdown;                                          //128748
                                                                                //128748
        // Push routine                                                         //128748
        SRIdx = SRIdx + 1;                                                      //128748
        SRStack(SRIdx) = 'CheckAndExecuteShutdown';                             //128748
                                                                                //128748
        // If program is being forcibly ended try to shut down as               //128748
        //  cleanly as possible                                                 //128748
        if %shtdn = '1';                                                        //128748
                                                                                //128748
           // This is sort of an error so set the error location to             //128748
           //  make the CL ROLLBACK, if in *SECURE mode.                        //128748
           Here = 'Feeder shutting down - cancelled by user';                   //128748
                                                                                //128748
           exsr ErrorSR;                                                        //128748
           return;                                                              //128748
        endif;                                                                  //128748
                                                                                //128748
        // Pop subroutine                                                       //128748
        clear SRStack(SRIdx);                                                   //128748
        SRIdx = SRIdx - 1;                                                      //128748
                                                                                //128748
        endsr;                                                                  //128748
       // ***************************************************************       //128748
      /EJECT                                                                    //128748
       // ***************************************************************
        begsr *inzsr;

        // Push routine
        SRIdx = SRIdx + 1;
        SRStack(SRIdx) = '*inzsr';

        // Get Feeder Sequence number and Mnemonic from QTEMP data area
        //  set up by calling CL
        // Then use Feeder Sequence number to update process name for log file
        // That is why this has to be before the startup message
        in FdrInfoDA;

        ProcessForLog = %trim( ProcessForLog) + FdrSeqNbr;

        // Log that the program is starting
        StringForLog = 'Replication Feeder started' +
                 ' at ' + %char(%timestamp());
        callp EntryOut(ProcessForLog : StringForLog);
        StringForLog = 'Restarting at journal sequence number ' +
                 %trim( StartingJrnSeqNbr) + ' at ' + %char(%timestamp());
        callp EntryOut(ProcessForLog : StringForLog);

        // Get Feeder Mode & Queue Manager name from Replication control data area
        // but do it via access objects and not directly                        //000820
        //**in RepnCtlDA;                                                       //000820
        callp RPBOIF99 ( MQMNameKey : BOIF99Data : BOIF99Len);                  //000820
        MQSeriesQMName = %subst( BOIF99Data : 1 : BOIF99Len);                   //000820
        callp RPBOIF99 ( FeederModeKey : BOIF99Data : BOIF99Len);               //000820
        FeederMode = %subst( BOIF99Data : 1 : BOIF99Len);                       //000820
                                                                                //128748
        // Also get Delay information as alpha and convert to numeric           //128748
        callp RPBOIF99 ( DlyTimeKey : BOIF99Data : BOIF99Len);                  //128748
        DelayTimeAlpha = %subst( BOIF99Data : 1 : BOIF99Len);                   //128748
        QFullDelayTime = %dec( DelayTimeAlpha : 10 : 0);                        //128748
        callp RPBOIF99 ( NumRptsKey : BOIF99Data : BOIF99Len);                  //128748
        NumRepeatsAlpha = %subst( BOIF99Data : 1 : BOIF99Len);                  //128748
        QFullNumRepeats = %dec( NumRepeatsAlpha : 10 : 0);                      //128748

        // Log Feeder mode
        StringForLog = 'Replication Feeder running in ' +
                 %trim( FeederMode) + ' mode at ' + %char(%timestamp());
        callp ErrorOut(ProcessForLog : StringForLog);

        // Common processing for both modes
        //=================================

        // Change the Structure version number from default (*VER1) to
        //  *VER2 so that selection fields may be specified.
        eval MDVER = MDVER2;
        eval PMVER = PMVER2;
        eval GMVER = GMVER2;

        exsr ConnectToQueueManager;

        exsr ConnectToTargetQueues;

        // Set up output fields that have constant values
        FQCountI      = 1;
        FQDS_Mnemonic = '  ';
        FQNull_Flag   = '0';

        // Processing for *SECURE mode
        //=================================

        // Open Last Journal Sequence Number file under CC
        if FeederMode = '*SECURE';

           open(e) RPFEEDSQNO;
           if %error = '1';
              StringForLog = 'Error occurred when opening file +
                       RPFEEDSQNO ' + %char(%timestamp());
              callp ErrorOut(ProcessForLog : StringForLog);
              Here = 'open RPFEEDSQNO';
              exsr ErrorSR;
           endif;

        // Get the Count of stored entries (no lock so need to update)
        chain(n) FdrSeqNbr RPFEEDSQNO;
        if %error = '1' or not %found;
           StringForLog = 'Error occurred when chaining to file +
                    RPFEEDSQNO with key ' + FdrSeqNbr + ' - see dump '+
                    %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
           Here = 'chain RPFEEDSQNO';
           exsr ErrorSR;
        endif;
        NbrPendMsgs = RGSTRNUM;

        // If count of how many entry have been stored is non-zero log this
        if NbrPendMsgs <> 0;
           StringForLog = 'There were ' + %char( NbrPendMsgs) +
                 ' Journal Entries outstanding from a previous run when +
                 the Feeder started ' + %char(%timestamp());
           callp ErrorOut(ProcessForLog : StringForLog);
        endif;

        // Open Buffer Queue and store the associated connection handle
           QNameToUseType = 'Buffer';
           BufferQName = 'FDRBUF' + Mnemonic + FdrSeqNbr;
           QNameToUse = BufferQName;
           exsr OpenQueue;
           HOBJBUFQ = HOBJ;

           PMSYPToUse = PMSYP;

        endif;

        // Processing for *FAST mode
        //=================================

        // Generate Last Journal Sequence Number read data area name
        if FeederMode = '*FAST';
           LastSeqNbrReadDAName = 'JDFDR' + Mnemonic + FdrSeqNbr;

           PMSYPToUse = PMNSYP;

        endif;

        // Get the current subsystem name
        GetSbsName(WhatToGet : CurrentSubsystem);

        // Log that the program initialisation is complete
        StringForLog = 'Replication Feeder initialisation is complete at '+
                 %char(%timestamp());
        callp TraceOut(ProcessForLog : StringForLog);

        // Pop subroutine
        clear SRStack(SRIdx);
        SRIdx = SRIdx - 1;

        endsr;

      /end-free
      ********************************************************************
