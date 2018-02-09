     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Hierarchy H/M Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100400 - Cash Management Hierarchy Hdr/Mbr Validation      *
      *                                                               *
      *  Function:  This program validates the cash management        *
      *             front end hierarchy headers and members.          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 215579             Date 17Mar03               *
      *                 212466             Date 10Jan03               *
      *                 CRE008  *CREATE    Date 06Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  215579 - Hierarchy validation error                          *
      *  212466 - Hierarchies become effective from next working day  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
      * F R O N T  E N D  F I L E S
      * ---------------------------
 
      * Account Hierarchy Header
     FREACCHPD  IF   E           K DISK    INFSR(*PSSR)
     FREACCHL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(REACCHD0:REACCHD1)
 
      * Group Account Header Extension
     FREGAHXPD  IF   E           K DISK    INFSR(*PSSR)
      * Account Hierarchy Member - TOP a/c
     FREACCMJL0 IF   E           K DISK    INFSR(*PSSR)
 
     FRE100400AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** File Information Data Structure for RE100400AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
      * Associated Hierarchies
     D AsocHier        S              9  0 DIM(100)
     D AsocHtyp        S              2    DIM(100)
 
 
      * Account Hierarchy Header
     D I_ACCH        E DS                  EXTNAME(REACCHPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
 
      /SPACE 5
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      * INTERACTIVE mode
      * Non INTERACTIVE mode
 
     C     I_MODE        IFEQ      'I'
     C                   EXSR      INTERACT
     C                   ELSE
     C                   EXSR      NON_INTERACT
     C                   ENDIF
 
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Interactive mode
      ********************************************************************
     C     INTERACT      BEGSR
 
      * Access hierarchy
      * Determine hierarchy currency
      * Extract headers
      * Extract members
 
     c                   MOVEL     'P'           I_RUN
     C                   MOVEL     I_Hierarchy   I_HIER
     C                   MOVEL     I_HierType    I_HTYP
     C     I_HIER        CHAIN     REACCHD0                           60
     C   60              CLEAR                   I_ACCH
     C                   EXSR      DET_HCCY
     C                   EXSR      EXT_HEADERS
     C     Ix            IFEQ      0
     C                   EXSR      EXT_MEMBERS
     C                   ENDIF
 
      * NORMAL EXIT if errors detected
 
     C     Ix            IFGT      0
     C                   RETURN
     C                   ENDIF
 
      * For all associated hierarchies
 
     C                   Z-ADD     1             Ah                3 0
 
     C     AsocHIER(Ah)  DOWNE     0
 
      * Access hierarchy
      * Determine hierarchy currency
      * Extract headers
      * Extract members
 
     c                   MOVEL     *BLANK        I_RUN
     C                   MOVEL     AsocHIER(Ah)  I_HIER
     C                   MOVEL     AsocHTYP(Ah)  I_HTYP
     C     I_HIER        CHAIN     REACCHD0                           60
     C   60              CLEAR                   I_ACCH
     C                   EXSR      DET_HCCY
     C                   EXSR      EXT_HEADERS
     C     Ix            IFEQ      0
     C                   EXSR      EXT_MEMBERS
     C                   ENDIF
 
      * Ignore errors in associated hierarchies
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
     C                   ADD       1             Ah
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Non-Interactive mode
      ********************************************************************
     C     NON_INTERACT  BEGSR
      ***************************************************************
      * Notes on Hierarchy Status and Authorized By User on REACCHPD*
      * Whenever a hierarchy is created or amended in the front end *
      *   Hierarchy Status -> 'W' (WIP) Authorized By User -> blank *
      * Whenever a hierarchy is authorized in the front end         *
      *   Hierarchy Status -> 'L' (LIVE) Authorized By User -> user *
      ***************************************************************
 
      * Read all Account Hierarchy Header records
 
     C                   READ      REACCHD1                               60
 
     C     *IN60         DOWEQ     *OFF
 
      * If the hierarchy does not have a status of 'WORK IN PROGRESS'
      * (i.e. it has a status of 'LIVE' or 'ERRORS')
      * and its date effective from is the next working day or in the past      212466
      **and*its*date*effective from is today or in the past                     212466
 
     C     HISTAT        IFNE      'W'
     C     HIDEFR        ANDLE     BJDNWD                                       212466
     C*****HIDEFR********ANDLE     BJRDNB                                       212466
 
      * Determine hierarchy currency
      * Extract headers
      * Extract members
 
     C                   MOVEL     HIID          I_HIER
     C                   MOVEL     HIHTYP        I_HTYP
     C                   EXSR      DET_HCCY
     C                   EXSR      EXT_HEADERS
     C     Ix            IFEQ      0
     C                   EXSR      EXT_MEMBERS
     C                   ENDIF
 
      * If any errors detected
      *   Report the errors
      *   Set status to 'ERRORS'
      * Else, set status to 'LIVE'
 
     C     Ix            IFGT      0
     C                   EXSR      REP_ERRORS
     C                   ADD       Ix            NoErrors          5 0
 
     C                   MOVE      'E'           HISTAT
     C                   EXCEPT    U_REACCH
 
     C                   SETON                                        U7U8
     C                   ELSE
 
     C                   MOVE      'L'           HISTAT
     C                   EXCEPT    U_REACCH
 
     C                   ENDIF
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIDArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
     C                   ENDIF
 
      * Read next Account Hierarchy Header record
 
     C                   READ      REACCHD1                               60
 
     C                   ENDDO
 
      * End of report
 
     C                   EXSR      END_OF_REP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine hierarchy currency
      ********************************************************************
     C     DET_HCCY      BEGSR
 
      * If a group a/c hierarchy
      *   Hierarchy currency = group a/c currency
      * If a zero balancing/sweeping hierarchy
      *   Hierarchy currency = currency of top a/c
 
     C     I_HTYP        IFEQ      'GA'
     C     I_HIER        CHAIN     REGAHXD0                           60
     C                   MOVEL     GHCCY         I_HCCY
     C                   ELSE
     C     I_HIER        CHAIN     REZSMXJ0                           60
     C                   MOVEL     ZMCCCY        I_HCCY
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Extract Headers
      ********************************************************************
     C     EXT_HEADERS   BEGSR
 
     C                   CALLB     'RE100401'
                                                                                215579
      * Return code                                                             215579
      * Error Message                                                           215579
     C                   PARM      *BLANKS       X_RTCD                         215579
     C                   PARM      *BLANKS       X_ERMS                         215579
      * INPUTS                                                                  215579
      * Mode
     C                   PARM                    I_MODE            1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HTYP            2
      * Account Hierarchy Header
     C                   PARM                    I_ACCH
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
                                                                                215579
     C     X_RTCD        IFEQ      '*ERROR'                                     215579
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT HEADERS'  215579
     C                   EXSR      *PSSR                                        215579
     C                   ENDIF                                                  215579
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Extract Members
      ********************************************************************
     C     EXT_MEMBERS   BEGSR
 
     C                   CALLB     'RE100402'
                                                                                215579
      * Return code                                                             215579
      * Error Message                                                           215579
     C                   PARM      *BLANKS       X_RTCD                         215579
     C                   PARM      *BLANKS       X_ERMS                         215579
      * INPUTS                                                                  215579
      * Mode
      * Run
     C                   PARM                    I_MODE            1
     C                   PARM                    I_RUN             1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HTYP            2
      * Hierarchy Currency
     C                   PARM                    I_HCCY            3
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * Associated Hierarchies
 
     C                   PARM                    AsocHier
     C                   PARM                    AsocHtyp
                                                                                215579
     C     X_RTCD        IFEQ      '*ERROR'                                     215579
     C                   EVAL      X_ERMS = 'ERROR IN CASH MANAGEMENT MEMBERS'  215579
     C                   EXSR      *PSSR                                        215579
     C                   ENDIF                                                  215579
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * Report Errors
      ********************************************************************
     C     REP_ERRORS    BEGSR
 
     C                   Z-ADD     1             IIx               3 0
     C     IIx           DOUGT     Ix
 
     C                   MOVEL     MsgIdArr(IIx) @MSGID            7
     C                   MOVEL     MsgDtaArr(IIx)@MSGDT           45
     C                   EXSR      ZAMSGRTVMS
     C     CompMsg       IFNE      *BLANK
     C                   EVAL      R_ERMS = CompMsg
     C                   ELSE
     C                   EVAL      R_ERMS = @MSGID
     C                   ENDIF
     C                   ADD       1             IIx
 
      * Output to report
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ERROR
 
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output count of errors and 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     6             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Retrieve a message
      ********************************************************************
     C     ZAMSGRTVMS    BEGSR
     C                   CALLB     'ZAMSGRTVMS'
     C                   PARM      *BLANK        ReturnCode       10
     C                   PARM      *BLANK        CompMsg        3000
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
     C                   PARM      'REUSRMSG  '  #MsgFile         10
     C                   PARM      '*LIBL  '     #MsgFLib         10
     C                   PARM      '0'           Level             1
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Register AU printer file with RCF
      ********************************************************************
     C     RCFAU         BEGSR
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Mode
     C                   PARM                    I_MODE            1
      * Hierarchy
      * Hierarchy Type
     C                   PARM                    I_Hierarchy       9 0
     C                   PARM                    I_HierType        2
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * If NOT interactive mode
      *   Open printer printer file
      *   Register AU printer file with RCF
 
     C     I_MODE        IFNE      'I'
     C                   OPEN      RE100400AU
     C                   EXSR      RCFAU
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     OREACCHD1  E            U_REACCH
     O                       HISTAT
