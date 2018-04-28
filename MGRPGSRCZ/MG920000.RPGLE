     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas MG Deletion/cancellation control pgm')           *
      *****************************************************************
      *                                                               *
      *  Midas - Message Management                                   *
      *                                                               *
      *  MG920000 - Midas MG Deletion/Cancellation Processing         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD028094           Date 25Nov14               *
      *  Prev Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD028094 - Deleted FXDN transaction created a cancellation   *
      *             entry on MGF300TR archive file                    *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
     FMGOREFL0  IF   E           K DISK    INFSR(*PSSR)
 
      **  Data structure for transaction number field
 
     D                 DS
     D DSTRNO                  1     16
     D  DSMODI                 1      2
     D  DSMTRN                 3      8  0
     D  DSTRID                 9     14
     D  DSSEQN                15     16  0
 
      **  Data structure to redefine MTRN as 6 long numeric field
 
     D                 DS
     D  MTRN                   1     15
     D  MTRNN                  1      6  0
     D  TRIDD                  7     12
 
      ** Data Structure for Module details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Data Structure for Switchable Features file
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
     D/COPY WNCPYSRC,MG9200I001
 
      ** Data structure for access programs
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Local data area
 
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
 
      ** Midas Phase Data area
 
     D MPHAS           DS             1
     D  COB                    1      1
 
      ** Variable Declaration
 
     D TNUM            S              6  0
     D TRID            S              6
     D PROG            S              2
     D MODI            S              2
     D DVRTNC          S              1
     D DVCLSS          S              1
     D STRNO           S             16
     D DVCARQ          S              1
     D DVPTST          S              1
     D MT3XX           S              1
     D HOLD1           S              1
     D DVMTPY1         S              1
     D DVWLD           S              3
     D DVWL2           S              3
     D WFIRST          S              1
     D DVTRNH          S             16
     D CDL008          S              1
     D DVSARD          S              6
     D DVRTCD          S              7
     D DVOPTN          S              7
     D DVTSEQ          S              3  0
      *****************************************************************
      /EJECT
      *****************************************************************
      *   Main process                                                *
      *****************************************************************
 
      ** Parameters passed from extraction program
 
     C     *ENTRY        PLIST
     C                   PARM                    TNUM
     C                   PARM                    TRID
     C                   PARM                    PROG
     C                   PARM                    MODI
     C                   PARM                    DVTSEQ
     C                   PARM                    DVRTNC
     C                   PARM                    DVCLSS
 
      **  Perform initial process
 
     C                   EXSR      INIT
 
      ** Do while transaction no. of LF/MGOREFL0 is equal to
      ** transaction no. of calling program
 
     C                   DOW       MTRNN = TNUM
     C                             AND TRIDD = TRID
     C                             AND TRIDD <> *BLANKS
     C**********                   AND MTRN = *BLANKS                                       MD028094
     C                             AND MTRN <> *BLANKS                                      MD028094
     C                             AND *IN10 = '0'
 
      ** Only do the main processing if not a cancellation message
      ** (ie. '192' or '292')
 
     C                   EVALR     DVWL2 = MTPY
     C**********         EVALR     DVWL2 = '**'                                             MD028094
     C                   MOVE      '**'          DVWL2                                      MD028094
     C                   EVALR     DVWLD = MTPY
     C**********         EVAL      DVWLD = '*'                                              MD028094
     C                   MOVEL     '*'           DVWLD                                      MD028094
 
     C                   IF        DVWLD <> '*92'
 
     C/COPY WNCPYSRC,MG9200C002
 
      **  Access header reference record if multiple record
 
     C                   EXSR      HEADR
 
      ** If parameter passed is 'CE'/'CA' must be confirmations
      ** extract. Else, must be a pay/receive extract
 
     C                   IF        PROG = 'CE'
     C                             OR PROG = 'CA'
 
     C/COPY WNCPYSRC,MG9200C009
 
      ** If COB, and a DEAM is being processed then only process
      ** Confirmations, as pay/receives for Deams are done in I/C.
 
     C                   IF        PROG = 'CA'
 
      ** TYPE 'CA'
 
     C                   IF        DVWL2 = '3**'
     C                             AND COB = 'C'
     C                   EXSR      CALL
     C                   ENDIF
 
     C                   ELSE
 
      ** TYPE 'CE'
 
     C                   EXSR      CALL
 
     C                   ENDIF
 
     C                   ELSE
 
     C/COPY WNCPYSRC,MG9200C011
 
     C                   ENDIF
 
      ** Re-access reference file using saved transaction ref.
 
     C     STRNO         CHAIN     MGOREFL0                           10
 
      **  If database error set up LDA and return
 
     C                   IF        *IN10 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   EVAL      DBKEY = DSTRNO
     C                   EVAL      DBFILE = 'MGOREFL0'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read previous message on reference file
 
     C                   READP     MGOREFD0                               10
 
     C                   ENDDO
 
      ** If a sent confirmation message was found indicate 'Cancel'
 
     C                   IF        PROG = 'CE'
     C                             AND MODI = 'DL'
     C                             AND DVTSEQ <> 0
     C                             AND *IN22 = '0'
     C                   EVALR     DVRTNC = 'C'
     C                   ENDIF
 
     C                   IF        MT3XX = 'C'
     C                   EVALR     DVRTNC = 'C'
     C                   ENDIF
 
      **  If CDL008 is on and deal was amended from CLS Settlement 'Y'
      *** to 'N', set return parameter to 'Y' to satisfy condition for
      **  generating new MT300 with codeword NEWT and MT392 cancellation
 
     C                   IF        CDL008 = 'Y'
     C                             AND WCLSS = 'Y'
     C                             AND DVCLSS = 'N'
     C                   EVALR     DVCLSS = 'Y'
     C                   ENDIF
 
      ** End program
 
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *  INIT - Initial processing                                    *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Check if COB or not
 
     C     *DTAARA       DEFINE                  MPHAS
     C                   IN        MPHAS
 
      ** Set up LDA
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVALR     DBFILE = *BLANKS
     C                   EVALR     DBKEY = *BLANKS
     C                   EVALR     DBPGM = *BLANKS
     C                   EVAL      DBPGM = 'MG9200'
     C                   Z-ADD     *ZERO         DBASE
     C                   OUT       LDA
 
      ** Check if CDL008 (Continuous Linked Settlement) is installed
 
     C                   MOVE      'N'           CDL008
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       DVRTCD
     C                   PARM      '*VERIFY'     DVOPTN
     C                   PARM      'CDL008'      DVSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        DVRTCD <> *BLANKS
     C                             AND DVRTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = DVSARD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        DVRTCD = *BLANKS
     C                   EVAL      CDL008 = 'Y'
     C                   ENDIF
 
      ** Initialise work field
 
     C     CDL008        IFEQ      'Y'
     C                   EVALR     WFIRST = *ON
     C                   ENDIF
 
      **  Set up key field for access of MGOREFL0 with values from
      **  calling program.
 
     C                   EVALR     DSMODI = MODI
     C                   EVAL      DSMTRN = TNUM
     C                   EVALR     DSTRID = TRID
     C                   EVAL      DSSEQN = *HIVAL
 
      **  Access last generated message for transaction number
 
     C     DSTRNO        SETGT     MGOREFL0                             10
 
      **  Exclude header of Mult MT210 and MT950's.
 
     C                   DOU       MTRN <> *BLANKS
     C                             OR *IN10 = '1'
     C                   READP     MGOREFD0                               10
     C                   ENDDO
 
      **  If beginning of file or database error set up LDA and return
 
     C                   IF        *IN10 = '1'
     C                             OR TNUM <> MTRNN
     C                             OR TRID <> TRIDD
 
     C                   IF        PROG = 'CE'
     C                             AND DVTSEQ <> 0
     C                   EVALR     DVRTNC = 'C'
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
 
      ** Else CDL008 is on and most recently generated confirmation is
      ** found, save CLS Settlement field.
 
     C                   ELSE
 
     C                   IF        CDL008 = 'Y'
     C                             AND MTPY = '300'
     C                   MOVE      CLSS          WCLSS             1
     C                   MOVE      *ON           WINDI             1
     C                   ELSE
     C                   EVALR     WINDI = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVALR     MT3XX = *BLANK
     C                   EVALR     HOLD1 = *BLANK
 
      ** Read AOMMODR0 to retrieve moduie information
 
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     DVRTCD
     C                   PARM      '*FIRST '     DVOPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** If a DB error , set up LDA and return to calling program
 
     C                   IF        DVRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY WNCPYSRC,MG9200C004
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  HEADR - Access header reference record if part of a multiple *
      *          message                                              *
      *****************************************************************
     C     HEADR         BEGSR
 
      ** Save transaction reference no., cancellation requested
      ** and part deleted status of the message being processed
 
     C                   EVALR     DSTRNO = TRNO
     C                   EVALR     STRNO = TRNO
     C                   EVALR     DVCARQ = CARQ
     C                   EVALR     DVPTST = PTST
 
      ** Check if a multiple message
 
     C                   IF        TRNF <> *BLANKS
     C                             OR TRNM <> *BLANKS
 
      ** Determine whether file pointer is on header reference record
      ** and set up key for chain to LF/MGOREFL0
 
     C                   IF        TRNF = *BLANKS
     C                   EVAL      DVTRNH = TRNO
     C                   ELSE
     C                   EVAL      DVTRNH = TRNF
     C                   ENDIF
 
      ** Chain to header reference record
 
     C     DVTRNH        CHAIN     MGOREFL0                           10
 
      ** If a DB error , set up LDA and return to calling program
 
     C     *IN10         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   EVAL      DBKEY = DVTRNH
     C                   EVAL      DBFILE = 'MGOREFL0'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  CALL  - Call cancellation or deletion program                *
      *****************************************************************
     C     CALL          BEGSR
 
      ** If a live message
 
     C                   IF        MGST = 'CRTD'
     C                             OR MGST = 'AMND'
 
     C/COPY WNCPYSRC,MG9200C003
 
      ** If message not already deleted
 
     C                   IF        DVPTST <> 'D'
 
      ** Call Deletion program
 
     C                   CALL      'MG920500'                           11
     C                   PARM                    DSTRNO
     C                   PARM                    MODI
     C                   PARM      *BLANK        DVRTNC
 
      ** If MG9205 not found , set up LDA and return to calling program
 
     C                   IF        *IN11 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   EVALR     DBKEY = 'MG920500 NOT FOUND'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If database error in MG9205 return control to calling program
 
     C                   IF        DVRTNC <> *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call cancellation of confirmations
 
     C                   EVAL      DVMTPY1 = MTPY
 
     C                   IF        DVMTPY1 = '3'
     C**********                   AND BGCFMT <> 'Y'                                        MD028094
     C                             AND BGCFMT = 'Y'                                         MD028094
     C                   CALL      'MG921000'                           12
     C                   PARM                    DSTRNO
     C                   PARM                    MODI
     C                   PARM      *BLANK        DVRTNC
 
      ** If MG9210 not found, set up LDA and return to calling program
 
     C                   IF        *IN12 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   EVALR     DBKEY = 'MG921000 NOT FOUND'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If database error in MG9210 return control to calling program
 
     C                   IF        DVRTNC <> *BLANK
     C                   Z-ADD     5             DBASE
     C                   EVALR     DBKEY = 'MG920000 ERROR'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** No MT330 Cancel conf should be generated if MT330 MGST
      ** found is 'CRTD' or 'AMND'
 
     C                   IF        MTPY = '300'
     C                   EVAL      *IN22 = '1'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** If message already sent or logically acknowledged ...
      ** ('PEND', 'TRAN', 'LACK', 'PRTD', 'RRTD'....)
      ** Use the message group codes for the above.
 
     C                   IF        MGSG = '2'
     C                             OR MGSG = '3'
      *
     C                   EVAL      HOLD1 = MTPY
 
      ** If CDL008 is on and current record is the most recently
      ** generated confirmation, save CLS Settlement field.
 
     C                   IF        CDL008 = 'Y'
     C                             AND MTPY = '300'
     C                             AND WINDI = *OFF
     C                   EVALR     WCLSS = WCLSS
     C                   EVALR     WINDI = *ON
     C                   ENDIF
 
      ** If CDL008 is on and CLS Settlement was changed from Y to N,
      ** generate MT392 cancellation.
 
     C                   IF        CDL008 = 'Y'
     C                             AND DVCARQ <> 'Y'
     C                             AND DVPTST <> 'D'
     C                             AND MTPY = '300'
     C                             AND WCLSS = 'Y'
     C                             AND DVCLSS = 'N'
     C                             AND WFIRST = *ON
 
     C                   MOVE      'Y'           WCANC             1
     C                   EVALR     WFIRST = *OFF
 
     C                   ELSE
 
     C                   EVALR     WCANC = 'N'
 
     C                   ENDIF
 
     C                   IF        DVCARQ <> 'Y'
     C                             AND HOLD1 <> '3'
     C                             AND DVPTST <> 'D'
     C                             OR WCANC = 'Y'
     C                   CALL      'MG9210'                             12
     C                   PARM                    DSTRNO
     C                   PARM                    MODI
     C                   PARM      *BLANK        DVRTNC
 
      ** If MG9210 not found , set up LDA and return to calling program
 
     C                   IF        *IN12 = '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   EVALR     DBKEY = 'MG9210 NOT FOUND'
     C                   EVAL      DBFILE = *BLANKS
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** If database error in MG9210 return control to calling program
 
     C                   IF        DVRTNC <> *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** First MT3xx message found was sent (need 'CANCEL' message)
 
     C                   IF        MTPY = '300'
 
     C                   EVAL      *IN22 = '1'
 
     C                   IF        MT3XX = ' '
     C                   EVALR     MT3XX = 'C'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR - Error handling                                       *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      DVRTNC = 'E'
     C                   SETON                                            LR
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
