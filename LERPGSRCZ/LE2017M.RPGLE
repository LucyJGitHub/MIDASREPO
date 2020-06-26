     H DEBUG FIXNBR(*INPUTPACKED)
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan Manager message transmission')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2017M - Lending PC Front-End Message Transmission          *
      *                                                               *
      *  Function:To enable the sending of messages from Midas to     *
      *           Loan Manager.                                       *
      *                                                               *
      *  Called By: LEC2011                                           *
      *                                                               *
      *  LEC2017  - Lending PC Front-End Drip Feed Control Program    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 02Dec19               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 216346             Date 27Mar03               *
      *                 203561  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD-53992                              *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  216346 - Replace CLND message with REST message to avoid     *
      *           confusion with Lending ICD dripfeed                 *
      *  203561 - Download to Loan Manager does not occur if LEC2016  *
      *           is not running. New program LE2017 added.           *
      *                                                               *
      *****************************************************************
     FLEDLLDPD  UF   E           K DISK    INFSR(*PSSR)
      *
     FLE2017AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      **********************************************************************
      *
      *  F U N C T I O N   O F  I N D I C A T O R S
      *
      *  30 - Control text 'Reason Code' on Printer File
      *  85 - Work indicator for TESTB op code
      *  88 - Work indicator for chain on LEDLLDPD file
      *
      *----------------------------------------------------------------
      *  U6 U7 U8 LR
      **********************************************************************
      *
      * Subroutine Stack
     D STK             S             10    DIM(99)
      *
      * Branch Code Array and related Drip Feed Message Queue
     D W#ABRCH         S                   DIM(999) LIKE(A8BRCD)
     D W#AMQQN         S                   DIM(999) LIKE(A8MQDF)
      * Drip Feed Message Queue Handles
     D W#AMQDH         S                   DIM(999) LIKE(P#HOBJ)
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      *
      **  Static Data Download Customer Lending ICD Message Format
     D DWS5MF        E DS                  EXTNAME(LES5MFPD)
      **  Long Data Structure for Access programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      **  Short Data Structure for Access programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      **  Static Data Download Start/End Message Format
     D DWX1MF        E DS                  EXTNAME(LEX1MFPD)
      *
      **  Message Format
     D W#MFMT          S                   LIKE(P#MFMT)
      *
      **  COB Phase variable                                                                  CCB020
     D COBST           S              4                                                       CCB020
      *                                                                                       CCB020
      * Program Status Data Structure
     D PSDS           SDS
     D  W#PGM            *PROC
     D  W#WSID               244    253
     D  W#USER               254    263
      *
      * MQI structures
      *
      * MQI named constants
     D***/COPY*QRPGLESRC,CMQR                                                               MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      * Object Descriptor - source and reply
     D MQOD            DS
     D***/COPY*QRPGLESRC,CMQODR                                                             MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      * Message Descriptor
     D MQMD            DS
     D***/COPY*QRPGLESRC,CMQMDR                                                             MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
      * Put message options
     D MQPMO           DS
     D***/COPY*QRPGLESRC,CMQPMOR                                                            MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041226
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      * Local data area for database error details
     D DBERR         E DS                  EXTNAME(LDA)
      *
      * Message Header Filler field 9 long. Pos 1-3 contains PC orig
      * branch (121055). Pos 4 contains journal image Rollback flag.
      * 5-9 not used.
      *
     D FILLER          DS             6
     D    ROLLB                1      1
      *
      **Midas*System*Phase*data*area***********************************                       CCB020
     D*MPHAS****     E DS                  EXTNAME(MPHAS)                                     CCB020
     D***PHASE**     E                     EXTFLD(MPHAS)                                      CCB020
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D P#HCONN         S             10I 0                                                  MD041126
     D P#HOBJ          S             10I 0                                                  MD041126
     D P#MLEN          S             10I 0                                                  MD041126
     D P#MFMT          S          32767A                                                    MD041126
     D P#CCODE         S             10I 0                                                  MD041126
     D P#RSCOD         S              9P 0                                                  MD041126
     D P#REASON        S             10I 0                                                  MD041126
     D P#OPTS          S             10I 0                                                  MD041126
     D P#QMNAME        S             48A                                                    MD041126
      **********************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#RTCD            7
     C                   PARM                    P#MTYP            4
     C                   PARM                    P#QTYP            4
     C                   PARM                    P#SERV            3
     C                   PARM                    P#BRCH            3
      *
      * Initial Processing
      *
     C                   EXSR      INITIAL
      * Main Processing
      *
     C                   EXSR      SELECT
      * If still connected to the MQ Manager
     C     WKCLOS        IFNE      'Y'
     C                   EXSR      CLOSE
     C                   ENDIF
      *
     C                   RETURN
      **********************************************************************
      * Determine which type of message transmission has been requested.
      * Call appropriate subroutine to load details into message format
      **********************************************************************
     C     SELECT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'SELECT  '    STK(@Q)
      *
     C                   MOVE      'N'           W#DBER            1
      *
     C                   SELECT
      *
      * Change Loan Manager to restricted state in preparation for download
      *
     C     P#MTYP        WHENEQ    'REST'
     C                   EXSR      LMRESTRICT
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that system may now be opened (Midas COB almost
      * completed, batch jobs now submitted)
      *
     C     P#MTYP        WHENEQ    'OPEN'
     C                   EXSR      LMOPEN
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that system may be re-opened as Midas COB has
      * returned to previous input cycle and batch jobs have been submitted
      *
     C     P#MTYP        WHENEQ    'ROPN'
     C                   EXSR      LMREOPEN
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that the Midas input cycle interface batch job
      * has been ended
      *
     C     P#MTYP        WHENEQ    'ENDI'
     C                   EXSR      LMENDI
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that the Midas input cycle drip feed batch job
      * has been ended
      *
     C     P#MTYP        WHENEQ    'ENDD'
     C                   EXSR      LMENDD
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that the Midas input cycle interface batch job
      * has been started
      *
     C     P#MTYP        WHENEQ    'STRI'
     C                   EXSR      LMSTRI
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Tell Loan Manager that the Midas input cycle drip feed batch job
      * has been started
      *
     C     P#MTYP        WHENEQ    'STRD'
     C                   EXSR      LMSTRD
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSL
      *
      * Set next available transaction reference and update
      * Control file depending on whether message is drip feed or bulk
      *
      * Drip feed message
      *
     C     P#QTYP        IFEQ      'TRIC'
     C     '#DRP'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#DRP'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Bulk download message
      *
     C     P#QTYP        IFEQ      'BULK'
     C     '#BLK'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#BLK'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Update control file
      *
     C                   Z-ADD     W#BTTR        BTTR
     C                   UPDATE    LEDLLDD0
      *
     C                   ENDSR
      **********************************************************************
      *   Set Up Message Format
      **********************************************************************
     C     MSGFRMT       BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'MSGFRMT'     STK(@Q)
      *
      *     Message Header
      *
      *   User
      *   Work Station
      *   System Date
      *   Time Stamp
      *   Continuation Flag
      *   Filler
      *   No. of Entries
      *
      *
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
     C                   MOVE      *BLANKS       X1FIL1
      * Clear rollback flag
     C                   MOVE      *BLANKS       ROLLB
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Put Message Processing
      **********************************************************************
     C     PMQPUT        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'PMQPUT  '    STK(@Q)
      *
      *
     C     X1MSGT        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     X1MSGT        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * GetMessage length
     C                   Z-ADD     BTML          W#MLEN
     C                   ADD       90            W#MLEN
      *
     C* Put message onto MQ message queue for each queue in the array
     C                   Z-ADD     1             X
     C     W#AMQQN(X)    DOWNE     *BLANK
      *
      *
      *   Message Header reference and sequence no
     C                   MOVEL     W#BTTR        W1BTTR           12
     C                   EVAL      X1TNRF=       W#ABRCH(X) + W1BTTR
     C                   MOVE      W1BTTR        X1TRSN
      *
      *
      *   Update Transaction Action
     C                   SELECT
      *
     C     W#DBER        WHENEQ    'Y'
     C                   MOVE      'D'           X1ACTN
      *
     C                   ENDSL
      *
      *   Specify that Format name consists entirely of characters
      *
     C                   MOVEL     FMSTR         MDFMT
      *
      *   Message Header
     C                   MOVEL     DWX1MF        W#MFMT
      *
      *
      * Put message
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Put message
      * I: Connection handle
      * I: Object handle
      * I: Message Descriptor:
      *      Report Options: no reports required
      *      Message Type: message not requiring a reply
      *      Message Priority: default priority
      *      Message Persistence: message is persistent
      * I: Put message options: use default values supplied
      * I: Length of the Message
      * I: Message Data
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQPUT         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#AMQDH(X)    P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM      W#MLEN        P#MLEN            9 0                      MD041126
     C**********         PARM      W#MFMT        P#MFMT        32767                        MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#AMQDH(X)    P#HOBJ                                     MD041126
     C                   Z-ADD     W#MLEN        P#MLEN                                     MD041126
     C                   EVAL      P#MFMT = W#MFMT                                          MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQPMO : P#MLEN :                           MD041126
     C                                    %ADDR(P#MFMT) : P#CCODE :                         MD041126
     C                                    P#REASON )                                        MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQPUT failed?
     C     P#CCODE       IFNE      CCOK
     C                   MOVEL     'MQPUT'       DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVE      '*FAILED'     P#RTCD
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      '*SENT  '     P#RTCD
     C                   ENDIF
      *
      * Update next available transaction reference
     C                   ADD       1             W#BTTR
      * Next queue
     C                   ADD       1             X
     C                   ENDDO
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Change Loan Manager to restricted state as Midas COB is almost
      *   finished and interface batch jobs have been submitted
      **********************************************************************
     C     LMRESTRICT    BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMRESTRICT'  STK(@Q)
      *
     C     P#MTYP        IFEQ      'REST'
      *
      ***If*MPHAS*=*B*(i/c*termination),*send*message*to*advise*Loan**                        CCB020
      ***Manager*-*COB*about*to start.********************************                        CCB020
      ** If MPHAS = C (Close of Business), send message to advise Loan                        CCB020
      ** Manager - COB is in progress                                                         CCB020
      *
     C******DTAARA       DEFINE                  MPHAS                                        CCB020
     C******LOCK         IN        MPHAS                                                      CCB020
     C**********         MOVE      PHASE         W#MPHAS           1                          CCB020
     C**********         OUT       MPHAS                                                      CCB020
      *
     C*****W#MPHAS       IFEQ      'B'                                                        CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C*******************MOVE      'CLND'        X1MSGT                                       216346
     C                   MOVE      'REST'        X1MSGT                                       216346
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*FIRST '     WWOPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EXSR      MSGFRMT
      *
      * Format and populate data
     C                   MOVE      BPBRCF        S5BRCF
     C                   MOVE      BPGEEB        S5GEEB
     C                   MOVE      BPBTIN        S5BTIN
     C                   Z-ADD     BPDBDY        S5DBDY
     C                   MOVE      BPDBKC        S5DBKC
     C                   MOVE      BPDASI        S5DASI
     C                   MOVE      BPGIAV        S5GIAV
     C                   MOVE      BPFAAU        S5FAAU
     C                   MOVE      BPFAAM        S5FAAM
     C                   MOVE      BPFAUT        S5FAUT
     C                   MOVE      BPLOAU        S5LOAU
     C                   MOVE      BPPPAU        S5PPAU
     C                   MOVE      BPPSAU        S5PSAU
     C                   MOVE      BPROAU        S5ROAU
     C                   MOVE      BPLMAU        S5LMAU
     C                   MOVE      BPMRAU        S5MRAU
     C                   MOVE      BPREAU        S5REAU
     C                   MOVE      BPTPAU        S5TPAU
     C                   MOVE      BPFEAU        S5FEAU
     C                   MOVE      BPFSAU        S5FSAU
     C                   MOVE      BPGUAU        S5GUAU
     C                   MOVE      BPCAAU        S5CAAU
     C                   MOVE      BPGRPR        S5GRPR
     C                   MOVE      BPGRIR        S5GRIR
     C                   MOVE      BPCONR        S5CONR
     C                   MOVE      BPAURV        S5AURV
     C                   MOVE      'Y'           S5COBS
      *
      * Move message format
     C                   MOVEL(P)  DWS5MF        W#MFMT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   ENDIF
      *
     C                   EXSR      CLOSE
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      * Close and exit
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to open Loan Manager as COB is nearly finished and
      *   interface batch jobs have now been submitted
      **********************************************************************
     C     LMOPEN        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMOPEN'      STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'OPEN'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to re-open Loan Manager as Midas COB has returned to
      *   previous input cycle and interface batch jobs have been submitted
      **********************************************************************
     C     LMREOPEN      BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMREOPEN'    STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'ROPN'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to inform Loan Manager that the interface job in
      *   Midas has been shut down
      **********************************************************************
     C     LMENDI        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMENDI'      STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'ENDI'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to inform Loan Manager that the drip feed job in
      *   Midas has been shut down
      **********************************************************************
     C     LMENDD        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMENDD'      STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'ENDD'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to inform Loan Manager that the interface job in
      *   Midas has been started
      **********************************************************************
     C     LMSTRI        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMSTRI'      STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'STRI'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Send message to inform Loan Manager that the drip feed job in
      *   Midas has been started
      **********************************************************************
     C     LMSTRD        BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'LMSTRD'      STK(@Q)
      *
      * Open Loan Manager message.
      *
     C                   MOVE      'STRD'        X1MSGT
      *
      * Message Header
     C                   MOVEL     W#USER        X1TRUS
     C                   MOVEL     W#WSID        X1TRWS
     C                   MOVE      W#SYSDAT      X1TRDS
     C                   MOVE      W#X1TRTS      X1TRTS
     C                   MOVE      *BLANKS       X1CONT
      *
      * Put Message
     C                   EXSR      PMQPUT
     C                   MOVE      *BLANKS       STK(@Q)
      *
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *   Close MQ queues
      **********************************************************************
     C     CLOSE         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'CLOSE'       STK(@Q)
      *
     C                   MOVE      'Y'           WKCLOS            1
      *
      * Close the MQ queues for each branch requested
     C                   Z-ADD     1             X
     C     W#AMQQN(X)    DOWNE     *BLANK
      *
      *
      * Close object
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Close object
      * I: Connection handle
      * I: Object handle
      * I: Close options: No optional close processing
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQCLOS        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#AMQDH(X)    P#HOBJ            9 0                      MD041126
     C**********         PARM      CONONE        P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#AMQDH(X)    P#HOBJ                                     MD041126
     C                   Z-ADD     CONONE        P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P#HCONN : P#HOBJ : P#OPTS :                     MD041126
     C                                      P#CCODE : P#REASON )                            MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQCLOSE failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQCLOS'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Next queue
     C                   ADD       1             X
     C                   ENDDO
      *
      *
      * Disconnect queue manager
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Disconnect queue manager
      * I: Connection handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQDISC        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQDISC( P#HCONN : P#CCODE :                              MD041126
     C                                     P#REASON )                                       MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQDISC failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQDISC'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      ' '           W#FTIME
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      **********************************************************************
      *  Initialisation
      **********************************************************************
     C     INITIAL       BEGSR
      *
     C                   Z-ADD     1             @Q                3 0
     C                   MOVEL     'INITIAL   '  STK(@Q)
      *
      *
     C     *LIKE         DEFINE    A8BRCD        WWBRCD
     C     *LIKE         DEFINE    X             XSV
     C     *LIKE         DEFINE    P#HCONN       W#HCONN
     C     *LIKE         DEFINE    P#HOBJ        W#HOBJ
     C     *LIKE         DEFINE    X1TRDS        W#SYSDAT
     C     *LIKE         DEFINE    X1TRTS        W#X1TRTS
     C     *LIKE         DEFINE    P#MLEN        W#MLEN
     C     *LIKE         DEFINE    BTNM          W#NOREC
     C     *LIKE         DEFINE    BTNM          W#BTNM
     C     *LIKE         DEFINE    BTML          W#BTML
     C     *LIKE         DEFINE    BTTR          W#BTTR
     C     *LIKE         DEFINE    BJCYCD        W#CCY
     C     *LIKE         DEFINE    DBKEY         W#DBKEY
      *
      * Initialise the DS length field and RECI
      *
     C                   Z-ADD     *ZERO         W#FSIZ            5 0
     C                   MOVE      *BLANKS       W#RECI            1
      *
      * Set up Database Error Details.
     C                   MOVEL     W#PGM         DBPGM
     C                   CLEAR                   DBFILE
     C                   CLEAR                   DBKEY
     C                   CLEAR                   DBASE
     C                   CLEAR                   @DUMP
      *
      * Retrieve Date Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        WWRTCD            7
     C                   PARM      '*FIRST'      WWOPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Set System Date
      *   Convert Midas system date to DDMMYYYY or MMDDYYYY
     C                   Z-ADD     BJRDNB        W#ZDAYN
     C                   EXSR      ZZA0140
     C                   MOVEL     W#ZDATE8      W#SYSDAT
      *
     C     W#FTIME       IFEQ      ' '
      *
      * Set up Arrays for new file
     C                   CLEAR                   W#AMQQN
     C                   CLEAR                   W#ABRCH
      *
     C                   MOVE      'N'           W#FTIME           1
     C                   Z-ADD     *ZERO         X                 2 0
      *
      * Set up arrays if single server request
      *
     C     P#SERV        IFNE      'ALL'
      *
      * Retrieve Queue details using branch code
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*KEY'        WWOPTN
     C                   PARM      P#BRCH        WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     P#BRCH        DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C*
     C                   Z-ADD     1             X
     C*
     C     P#QTYP        IFEQ      'TRIC'
     C                   MOVEL     A8MQDF        W#AMQQN(X)
     C                   MOVEL     A8BRCD        W#ABRCH(X)
     C                   ENDIF
     C     P#QTYP        IFEQ      'BULK'
     C                   MOVEL     A8MQBU        W#AMQQN(X)
     C                   MOVEL     A8BRCD        W#ABRCH(X)
     C                   ENDIF
      *
      * Else process as all server request
      *
     C                   ELSE
      *
      * Retrieve first Queue name
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*FIRST'      WWOPTN
     C                   PARM      *BLANKS       WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Load all non-duplicate Drip Feed Queue names and the branches into
      * the respective arrays
     C     P#QTYP        IFEQ      'TRIC'
     C     WWRTCD        DOWEQ     *BLANKS
     C     A8MQDF        IFNE      *BLANKS
     C     A8MQDF        LOOKUP    W#AMQQN                                80
     C     *IN80         IFEQ      *OFF
     C                   ADD       1             X                 2 0
     C                   MOVEL     A8MQDF        W#AMQQN(X)
     C                   MOVEL     A8BRCD        W#ABRCH(X)
     C                   ENDIF
     C                   ENDIF
      *
      * Retrieve next Branch and Queue name
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*NEXT '      WWOPTN
     C                   PARM      *BLANKS       WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C     WWRTCD        ANDNE     '*EOF'
     C                   MOVEL     '*NEXT '      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
      * Load all non-duplicate Bulk Queue names and the branches into
      * the respective arrays
     C     P#QTYP        IFEQ      'BULK'
     C     WWRTCD        DOWEQ     *BLANKS
     C     A8MQBU        IFNE      *BLANKS
     C     A8MQBU        LOOKUP    W#AMQQN                                80
     C     *IN80         IFEQ      *OFF
     C                   ADD       1             X                 2 0
     C                   MOVEL     A8MQBU        W#AMQQN(X)
     C                   MOVEL     A8BRCD        W#ABRCH(X)
     C                   ENDIF
     C                   ENDIF
      *
      * Retrieve next Branch and Queue name
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       WWRTCD
     C                   PARM      '*NEXT '      WWOPTN
     C                   PARM      *BLANKS       WWBRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *   Error?
     C     WWRTCD        IFNE      *BLANKS
     C     WWRTCD        ANDNE     '*EOF'
     C                   MOVEL     '*NEXT '      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If X=0 No Drip Feed Q-names have been picked up - Problem
      *
     C     X             IFEQ      0
     C     P#QTYP        IFEQ      'TRIC'
     C                   EVAL      W#DBKEY= 'No Drip Feed Q-names on file'
     C                   ENDIF
     C     P#QTYP        IFEQ      'BULK'
     C                   EVAL      W#DBKEY= 'No Bulk Q-names on file'
     C                   ENDIF
     C                   MOVEL     W#DBKEY       DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Save value of last queue in array
     C                   Z-ADD     X             XSV
      *
      * Connect to MQ Manager explicitly
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Connect queue manager
      * I: Queue manager cleared to get the default queue manager
      * O: Connection handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQCONN        P#CID             9 0                      MD041126
     C**********         PARM      *BLANKS       P#QMNAME         48                        MD041126
     C*****W#HCONN       PARM      *ZERO         P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   EVAL      P#QMNAME = *BLANKS                                       MD041126
     C                   Z-ADD     *ZERO         P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( P#QMNAME : P#HCONN :                             MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#HCONN       W#HCONN                                    MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQConnect failed?
     C     P#CCODE       IFEQ      CCFAIL
     C                   MOVEL     'MQCONN'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C* Open MQ queue for each queue name in array
     C                   Z-ADD     1             X
     C                   DO        XSV           X
      *
      *
      * Object Name: MQ Queue Name
     C                   MOVEL     W#AMQQN(X)    ODON
      *
      * Object queue manager name: *blank denotes queue manager to
      *                            which the application is connected
     C                   CLEAR                   ODMN
      *
      * Open object
     C**********         CALL      'QMQM'                                                   MD041126
      * I: Call Id: Open object
      * I: Connection handle
      * I: Object Descriptor:
      *      Object Name: MQ Drip Feed Queue Name
      *      Object queue manager name: *blank
      * I: MQOPEN Options: Open to put messages
      * O: Object handle
      * O: Completion code
      * O: Reason code
     C**********         PARM      MQOPEN        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM      OOOUT         P#OPTS            9 0                      MD041126
     C*****W#AMQDH(X)    PARM      *ZERO         P#HOBJ            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     OOOUT         P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#HOBJ                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P#HCONN : MQOD :                                 MD041126
     C                                     P#OPTS  : P#HOBJ :                               MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#HOBJ        W#AMQDH(X)                                 MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
                                                                                            MD041126
      *   MQOPEN failed?
     C     P#RSCOD       IFNE      RCNONE
     C                   MOVEL     'MQOPEN'      DBKEY
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Set Transaction Action
     C                   CLEAR                   X1ACTN
      *
      *
      * Set Timestamp
     C                   MOVE      '00000000'    W#X1TRTS
     C                   TIME                    W#TIME            6 0
     C                   MOVEL     W#TIME        W#X1TRTS
      *
      * Get Control Details depending on queue type specified
      *
      * Drip feed queue
      *
     C     P#QTYP        IFEQ      'TRIC'
     C     '#DRP'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#DRP'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Bulkdownload queue
      *
     C     P#QTYP        IFEQ      'BULK'
     C     '#BLK'        CHAIN     LEDLLDPD                           88
     C     *IN88         IFEQ      *ON
     C                   MOVEL     '#BLK'        DBKEY
     C                   MOVEL     'LEDLLDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      * Set next available transaction reference
     C                   Z-ADD     BTTR          W#BTTR
      *
     C                   Z-ADD     0             W5FACT            3 0
     C                   Z-ADD     0             W5FCNO            2 0
     C                   Z-ADD     0             W6FACT            3 0
     C                   Z-ADD     0             W6FCNO            2 0
      *
     C                   MOVE      *BLANK        WKCLOS
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
      ** Check if Midas is in COB Phase                                                       CCB020
      *                                                                                       CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM                    COBST                                        CCB020
      *                                                                                       CCB020
     C                   ENDSR
      **********************************************************************
      *  ZZA0140   - Convert dayno to DDMMYYYY or MMDDYYYY
      *
      * I: Run Day Number in W#ZDAYN  5N 0
      * I: Date Format in BJDFIN from BANK ICD
      * O: Date in W#ZDATE8           8A
      **********************************************************************
     C     ZZA0140       BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'ZZA0140   '  STK(@Q)
      *
      * Convert Midas dayno
      *
     C     W#ZDAYN       IFGT      *ZERO
      *
     C                   CALLB     'ZA0140M'
      * O: Return Code
      * I: Midas Day Number
      * I: Midas Date Format  D or M
      * O: Date DDMMYY or MMDDYY
      * O: Date DDMMMYY
      * O: Date YYYYMMDD
      * O: Date DDMMYYYY or MMDDYYYY
      *
     C                   PARM      *BLANK        P#ZRTN            1
     C                   PARM      W#ZDAYN       P#ZDAYN           5 0
     C                   PARM      BJDFIN        P#ZDFMT           1
     C                   PARM      *ZERO         P#ZDATE           6 0
     C                   PARM      *BLANK        P#ZDATA           7
     C                   PARM      *ZERO         P#ZDAT8           8 0
     C     W#ZDATE8      PARM      *ZERO         P#ZDAT8F          8 0
      *
     C                   MOVEL     W#ZDATE8      W#DATE8
      *
     C                   ELSE
     C                   MOVEL     *BLANKS       W#DATE8           8
     C                   ENDIF
      *
     C     *LIKE         DEFINE    P#ZDAYN       W#ZDAYN
     C     *LIKE         DEFINE    P#ZDAT8       W#ZDATE8
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *   Audit File Processing
      *****************************************************************
     C     AUDIT         BEGSR
      *
     C                   ADD       1             @Q
     C                   MOVEL     'AUDIT   '    STK(@Q)
      *
     C                   OPEN      LE2017AU
      * Log audit report to RCF
     C                   Z-ADD     SFNUMU        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       WPARM             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
      * Print Header for Audit Report
     C                   WRITE     HEADAU
      * Print Database Error Details
     C                   WRITE     DBERROR
      *
     C                   MOVE      *BLANKS       STK(@Q)
     C                   SUB       1             @Q
      *
     C                   ENDSR
      *****************************************************************
      *
      *  *PSSR - Exception error processing
      *      Calls - NONE
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      *   If an error has occurred within this program, update LDA, set
      *   error switches, dump program and return to calling program.
      *
     C     @DUMP         IFEQ      *BLANK
     C                   DUMP
      *
      * Audit report required?
     C     DBFILE        IFNE      *BLANKS
     C                   EXSR      AUDIT
     C                   ENDIF
      *
      * If there is an error other than a failure with QMQM accessing close
      * down all queues.
      *
     C     P#CCODE       IFEQ      CCOK
     C     STK(@Q)       ANDNE     'INITIAL'
     C                   EXSR      CLOSE
     C                   ENDIF
      *
     C                   MOVE      'Y'           @DUMP             1
     C                   MOVE      ' '           W#FTIME
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVE      DBERR         @LDA
     C                   OUT       @LDA
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
