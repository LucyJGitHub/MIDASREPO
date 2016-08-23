     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY SWIFT Ref popup retrieve a record')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPSWR - FT Incoming payments Swift reference retrieve      *
      *            a record                                           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Last Amend No. CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP084  *CREATE    Date 25Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW209 - SWIFT 2009 Changes (Recompile)                      *
      *  CAP084 - Thin Client API Wrappers                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FMEINDTS1  IF   E           K DISK
      ** SPN : Incoming Message Detail   Detail to Detail
 
     FMEINCRL1  IF   E           K DISK
      ** RTV : Incoming Message Control  Retrieval index
 
     FMETAGTL1  IF   E           K DISK
      ** RTV : Message Tag X-Ref         Retrieval index
 
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D PMSDTA          DS           132
     D  PMPART                 1      2P 0 INZ(*ZEROS)
 
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D TranInIPSW    E DS                  EXTNAME(FTIPSWPD)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D MEPART          S              3P 0 INZ(*ZERO)
     D MENARR          S             76A   INZ(*BLANKS)
 
     D WStr            S              5P 0 INZ(*ZERO)
     D WLen            S              5P 0 INZ(*ZERO)
     D WFirst          S              1A   INZ(*BLANK)
     D WRUN            S              1A   INZ(*BLANK)
 
     D PMSGF           S            256A
     D PMSGID          S              7A
     D PMSTX1          S            132A
     D PMSTX2          S            512A
     D DDMSGR_In       S              8A
     D DDPART_In       S              3A
     D APIRetc         S              1A
     D Buffer          S           6000A
     D PErrMs          S              7A   INZ(*BLANKS)
     D WTIME           S              4A
     D WDATE           S              6A
     D WSTIME          S              5A
     D WSDATE          S              8A
 
     I@INDTS1       60
     I@IN35S1       61
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   CLEAR                   Buffer
     C                   CLEAR                   TranInIPSW
 
      ** Validate reference entered
     C                   EXSR      SRValdKey
 
      ** Display error message if problems found when reading the
      ** incoming payment
     C                   IF        PErrMS <> *BLANKS
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      SRSndM
     C                   ENDIF
 
      ** If no errors found, read details
     C                   IF        PErrMs = *BLANKS
 
     C                   Z-ADD     0             SVPART
     C                   MOVEA     '00'          *IN(60)
     C     KMsgRef       READE     MEINDTS1                               01
 
     C                   DOW       *IN01 = *OFF
 
      ** Initialise fields
     C                   EXSR      SRResetFlds
 
      ** Process details
     C                   EXSR      SRProc
 
      ** Read next DBF record
     C                   MOVEA     '00'          *IN(60)
     C     KMsgRef       READE     MEINDTS1                               01
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      Buffer = TranInIPSW
      ** End program
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValdKey - Validate swift reference                         *
      *                                                               *
      *****************************************************************
     C     SRValdKey     BEGSR
 
      ** Check reference to Incoming Message Control
     C     KMsgRef       CHAIN     MEINCRL1                           01
 
     C                   IF        *IN01
     C                   EVAL      PErrMs = 'MIN0011'
     C                   GOTO      ESRValdKey
     C                   ENDIF
 
     C                   EVAL      WNWRK = CRNWRK
     C                   EVAL      WMTPY = CRMTPY
 
      ** Check if records exist, if not, generate error
 
     C     KMsgRef       SETLL     MEINDTS1                               90
 
     C                   IF        *IN90 = *OFF
     C                   EVAL      PErrMs = 'MIN0011'
     C                   ENDIF
 
      ** Set up header values
     C                   EVAL      DDMSGR = DDMSGR_In
     C                   EVAL      DDNPRT = DDPART_In
     C                   EVAL      DDNWRK = CRNWRK
     C                   EVAL      DDSNDR = CRSNDR
     C                   EVAL      DDBRCA = CRBRCA
     C                   EVAL      DDMIR  = CRMIR
     C                   EVAL      DDMOR  = CRMOR
     C                   EVAL      DDMTPY = CRMTPY
     C                   EVAL      DDMPRY = CRMPRY
 
     C                   MOVEL     CRMODE        WDATE
     C                   MOVEL     CRMOTM        WTIME
     C                   EXSR      SRFDat
     C                   EVAL      DDMODE = WSDATE
     C                   EVAL      DDMOTM = WSTIME
     C
     C                   MOVEL     CRSNTD        WDATE
     C                   MOVEL     CRSNTT        WTIME
     C                   EXSR      SRFDat
     C                   EVAL      DDSNTD = WSDATE
     C                   EVAL      DDSNTT = WSTIME
     C                   EVAL      DDDUPF = CRDUPF
 
     C     ESRValdKey    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProc - Process details                                     *
      *                                                               *
      *****************************************************************
 
     C     SRProc        BEGSR
 
      ** If part read is equal to passed part or equal to zero display
      ** or whole message to be displayed, display record
 
     C                   IF        *IN60
     C                   Z-ADD     DTPART        MEPART
     C                   ELSE
     C                   Z-ADD     DSPART        MEPART
     C                   ENDIF
 
     C                   IF        PPART = MEPART OR
     C                             PPART = *ZERO  OR
     C                             MEPART = *ZERO
 
      ** If part change either print blank line or part information
 
     C                   IF        MEPART <> SVPART
     C                   EXSR      SRPLin
     C                   ENDIF
 
     C                   EXSR      SRMEFld
 
      ** If second line display
 
     C                   IF        POMDT2 <> *BLANKS
     C                   EVAL      MENARR = POMDT2
     C                   EXSR      SRWrite
     C                   ENDIF
 
      ** If third line display
 
     C                   IF        POMDT3 <> *BLANKS
     C                   EVAL      MENARR = POMDT3
     C                   EXSR      SRWrite
     C                   ENDIF
 
      ** If fourth line display
 
     C                   IF        POMDT4 <> *BLANKS
     C                   EVAL      MENARR = POMDT4
     C                   EXSR      SRWrite
     C                   ENDIF
 
      ** If fifth line display
 
     C                   IF        POMDT5 <> *BLANKS
     C                   EVAL      MENARR = POMDT5
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMEFld - Populate ME Fields                                 *
      *                                                               *
      *****************************************************************
 
     C     SRMEFld       BEGSR
 
      ** 100 long field
 
     C                   IF        *IN60
     C                   MOVEL     DTMTG         WMTG
     C                   MOVEL     DTMFLD        WMFLD
     C                   MOVEL     DTFPID        WFPID
     C                   ENDIF
 
      ** 35 long field
 
     C                   IF        *IN61
     C                   MOVEL     DSMTG         WMTG
     C                   MOVEL     DSMF35        WMFLD
     C                   MOVEL     DSFPID        WFPID
     C                   ENDIF
 
      ** Format data for display
 
     C                   CALL      'ME1010F0'                           9090
     C                   PARM      *BLANKS       P0RTN             7
     C                   PARM      WNWRK         WO0001            6
     C                   PARM      WMTG          WO0002            5
     C                   PARM      WMTPY         WO0003            3
     C                   PARM      WFPID         WO0004            1
     C                   PARM      WMFLD         WO0005          100
     C                   PARM      *BLANKS       POMDTA           76
     C                   PARM      *BLANKS       POMDT2           76
     C                   PARM      *BLANKS       POMDT3           76
     C                   PARM      *BLANKS       POMDT4           76
     C                   PARM      *BLANKS       POMDT5           76
     C                   PARM      *BLANKS       PORDTA          120
     C                   PARM      *BLANKS       PORDT2          120
     C                   PARM      *BLANKS       PORDT3          120
     C                   PARM      *BLANKS       PORDT4          120
 
      ** Add the first details in the buffer
 
     C                   IF        WFirst <> 'Y'
     C                   EVAL      WStr = 1
     C                   EVAL      WLen = 76
     C                   EVAL      WFirst = 'Y'
     C                   ENDIF
 
     C                   MOVEL     POMDTA        MENARR
     C                   EXSR      SRWrite
 
      ** Option ended in error
 
     C                   IF        *IN90 OR
     C                             P0RTN <> *BLANKS
     C                   EVAL      PErrMs = 'MIN0017'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPLin - Write part line to screen                            *
      *                                                               *
      *****************************************************************
 
     C     SRPLin        BEGSR
 
      ** Translate part line number
 
     C                   IF        MEPART > 0
     C                   Z-ADD     MEPART        PMPART
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0088'     PMSGID
     C                   PARM      'MEMSG'       PMSGF
     C                   PARM                    PMSDTA
     C                   PARM      *BLANKS       PMSTX1
     C                   PARM      *BLANKS       PMSTX2
 
      ** Option ended in error
 
     C                   IF        *IN90
     C                   EVAL      PErrMs = 'MIN0017'
     C                   EXSR      SRSndM
     C                   ENDIF
 
     C                   MOVEL     PMSTX1        MENARR
     C                   ENDIF
 
     C                   EXSR      SRWrite
 
     C                   Z-ADD     MEPART        SVPART
     C                   MOVEL     *BLANKS       MENARR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write details to output buffer                      *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      %SUBST(DDBUFF:WStr:WLen) = MENARR
     C                   EVAL      WStr = WStr + WLen
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset fields                                   *
      *                                                               *
      *****************************************************************
 
     C     SRResetFlds   BEGSR
 
     C                   Z-ADD     *ZERO         MEPART
     C                   CLEAR                   MENARR
     C                   CLEAR                   WMTG
     C                   CLEAR                   WMFLD
     C                   CLEAR                   WFPID
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFDat - Format date and time                                *
      *                                                               *
      *****************************************************************
      *
     C     SRFDat        BEGSR
 
     C                   IF        BJMRDT = 'D'
     C                   EVAL      WSDATE = %SUBST(WDATE:5:2) + '/' +
     C                                      %SUBST(WDATE:3:2) + '/' +
     C                                      %SUBST(WDATE:1:2)
     C                   ELSE
     C                   EVAL      WSDATE = %SUBST(WDATE:3:2) + '/' +
     C                                      %SUBST(WDATE:5:2) + '/' +
     C                                      %SUBST(WDATE:1:2)
     C                   ENDIF
 
     C                   EVAL      WSTIME = %SUBST(WTIME:1:2) + ':' +
     C                                      %SUBST(WTIME:3:2)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM        BEGSR
 
      ** Add error message to array passed to screen.
 
     C                   Z-ADD     1             Ex                3 0
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     PErrMs        MsgIdArr(Ex)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUT
      ** =====
 
      ** Message Reference
     C                   PARM                    DDMSGR_In
 
      ** Message Part
     C                   PARM                    DDPART_In
 
      ** OUTPUT
      ** ======
 
      ** Buffer
     C                   PARM                    Buffer
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
 
      ** API Return Code
     C                   PARM                    APIRetc
 
      ** Set up the names of the message files from which the message handler
      ** will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTIPAYM01
 
      ** Access Bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd             7
     C                   PARM      '*FIRST '     POptn             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Move parameters to numeric fields
 
     C                   EVAL      PMSGR = *ZERO
     C                   EVAL      PPART = *ZERO
 
     C                   MOVEL     DDMSGR_In     PMSGR             8 0
     C                   MOVEL     DDPART_In     PPART             3 0
 
      ** Define work variables
 
     C     *LIKE         DEFINE    CRNWRK        WNWRK
     C     *LIKE         DEFINE    CRMTPY        WMTPY
     C     *LIKE         DEFINE    DTMTG         WMTG
     C     *LIKE         DEFINE    DTMFLD        WMFLD
     C     *LIKE         DEFINE    DTFPID        WFPID
     C     *LIKE         DEFINE    DSPART        SVPART
 
      ** Set up key fields
     C     KMsgRef       KLIST
     C                   KFLD                    PMSGR
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
