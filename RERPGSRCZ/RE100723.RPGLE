     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Input Cycle Sweeps Shadow Posting')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100723 - Input Cycle Sweeps Shadow Posting                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. 213196             Date 17Mar03               *
      *                 214360  *CREATE    Date 03Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  214360 - Cash Management Deferred Posting                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *     LR        Last Record Indicator (Program Termination)     *
      *     U7 and U8 DB Error Processing Indicator                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SHP_ENTRY - Subroutine to Shadow Post Entry                   *
      * SRAudit   - Subroutine to Output Audit Report                 *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *****************************************************************
 
      ** RE Input Cycle Zero Bal/Sweeps - Details With Shadow Post Outstanding
     FREICSDL8  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** RE Input Cycle Zero Bal/Sweeps - Items
     FREICSIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Postings in Transit
     FGLPSTTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
 
      ** RE Input Cycle Zero Bal/Sweeps Shadow Posting - Audit
     FRE100723AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
                                                                                213196
      * Cash Management Hierarchy Details                                       213196
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)                    213196
     D A_HIER                  1      9
      * Zero Balancing/Sweeping Hierarchy Details                               213196
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)                    213196
      * Group Account Hierarchy Details                                         213196
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)                    213196
                                                                                213196
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** GL Postings in Transit
     D I_ENTRY       E DS                  EXTNAME(GLPSTTPD)
     D                                     PREFIX(E_)
 
 
      ** File Information Data Structure for RE100723AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
      ** Key Fields
     D KHierID         S              9  0
     D KLink           S              9  0
     D KPrDate         S              5  0
     D KSeqNum         S              2  0
     D KRefID          S              3
     D KRefNum         S             10  0
 
     D WkCnt1          S              5  0
     D WkCnt2          S              5  0
     D WkRefNum        S             10
 
      /SPACE 5
 
 
     C                   EVAL      WkCnt1 = 0
     C                   EVAL      WkCnt2 = 0
 
      ** Read all records in LF/REICSDL8
 
     C     *LOVAL        SETLL     REICSDL8
     C                   READ      REICSDL8                               89
 
     C                   DOW       *IN89 = *Off
                                                                                213196
      * Access Hierarchy Detail                                                 213196
                                                                                213196
     C                   EXSR      ACS_HIER                                     213196
                                                                                213196
      * Check if today is a working day in the account currency                 213196
                                                                                213196
     C                   Exsr      Det_WrkDay                                   213196
                                                                                213196
      * Do shadow posting if the message will be generated (by RE101303)        213196
      * External topping and sweeping messages are only generated:              213196
      * i.  On working days                                                     213196
      * ii. On non-working days only if holidays included & the msg is a 103    213196
                                                                                213196
     C     Ac_Ccy_WrkDay IFEQ      'Y'                                          213196
     C     Ac_Ccy_WrkDay OREQ      'N'                                          213196
     C     ZDSHOC        ANDEQ     'I'                                          213196
     C     IDTPSW        ANDEQ     'S'                                          213196
 
      ** Set up Key Fields
 
     C                   EVAL      KHierID = IDHIER
     C                   EVAL      KLink   = IDLINK
     C                   EVAL      KPrDate = IDPRCD
     C                   EVAL      KSeqNum = IDSNUM
 
     C     KIncZSW       SETLL     REICSIL0
     C     KIncZSW       READE     REICSIL0                               88
 
      ** Retrieve the posting record
 
     C                   DOW       *IN88 = *Off
     C                   EVAL      KRefID  = 'ZS '
     C                   EVAL      KRefNum = IIXRFN
     C     KPostRef      CHAIN     GLPSTTL0                           87
 
      ** Database error if not found
 
     C                   IF        *IN87 = *On
     C                   MOVE      KRefNum       WkRefNum
     C                   EVAL      X_ERMS = 'No GLPSTTPD for '
     C                                       + KRefID + WkRefNum
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Shadow Post an Entry in Transit
 
     C                   EXSR      SHP_ENTRY
 
      ** Increment counter for the no. of records posted
 
     C                   EVAL      WkCnt2 = WkCnt2 + 1
 
     C     KIncZSW       READE     REICSIL0                               88
     C                   ENDDO
 
      ** Update REICSDL8 record
 
     C                   EVAL      IDSPTD = 'Y'
     C                   EXCEPT    U_REICSD
 
      ** Commit updates
 
     C                   COMMIT
                                                                                213196
     C                   Endif                                                  213196
 
      ** Increment counter for the no. of records read
 
     C                   EVAL      WkCnt1 = WkCnt1 + 1
 
     C                   READ      REICSDL8                               89
     C                   ENDDO
 
      ** Produce the Audit Report
 
     C                   EVAL      RCount1 = WkCnt1
     C                   EVAL      RCount2 = WkCnt2
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *On
 
      /SPACE 5                                                                  213196
      ********************************************************************      213196
      * Access Hierarchy Detail                                                 213196
      ********************************************************************      213196
     C     ACS_HIER      BEGSR                                                  213196
                                                                                213196
     C                   CALLB     'RE100601'                                   213196
      * Return code                                                             213196
      * Error Message                                                           213196
     C                   PARM      *BLANK        X_RTCD                         213196
     C                   PARM      *BLANK        X_ERMS                         213196
      * Option                                                                  213196
     C                   PARM      '*ALL   '     X_OPTN            7            213196
      * Hierarchy ID                                                            213196
     C                   PARM      IDHIER        I_HIER            9 0          213196
      * Hierarchy Type                                                          213196
     C                   PARM      *BLANK        I_HTYP            2            213196
                                                                                213196
     C                   PARM                    O_CMHD                         213196
     C                   PARM                    O_ZSHD                         213196
     C                   PARM                    O_GAHD                         213196
                                                                                213196
      * End if error occurred in module                                         213196
                                                                                213196
     C     X_RTCD        IFEQ      '*ERROR'                                     213196
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER    213196
     C                   EXSR      *PSSR                                        213196
     C                   ENDIF                                                  213196
                                                                                213196
     C                   ENDSR                                                  213196
      *******************************************************************       213196
      /SPACE 5                                                                  213196
      ********************************************************************      213196
      * Determine if today is a working day in a/c currency                     213196
      ********************************************************************      213196
     C     Det_WrkDay    BEGSR                                                  213196
                                                                                213196
     C                   CALLB     'ZCHKH'                                      213196
     C                   PARM      BJRDNB        ZDAYNO            5 0          213196
     C                   PARM      IDCCCY        ZCCY              3            213196
     C                   PARM      *BLANK        ZLOC              3            213196
     C                   PARM      *BLANK        ZHOLID            1            213196
     C     ZHOLID        IFEQ      'H'                                          213196
     C                   MOVEL     'N'           Ac_Ccy_WrkDay     1            213196
     C                   ELSE                                                   213196
     C                   MOVEL     'Y'           Ac_Ccy_WrkDay                  213196
     C                   ENDIF                                                  213196
                                                                                213196
     C                   ENDSR                                                  213196
      ********************************************************************      213196
      /SPACE 5
      ********************************************************************
      * Shadow post entry
      ********************************************************************
     C     SHP_ENTRY     BEGSR
 
     C                   CALLB     'RE100605'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * INPUTS
      * Entry
     C                   PARM                    I_ENTRY
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN SHADOW POST ENTRY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *****************************************************************
      * SRAudit - Write the Audit Report                              *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
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
 
     C                   WRITE     HEADAU
     C                   WRITE     HASRUN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Key Lists
 
     C     KIncZSW       KLIST
     C                   KFLD                    KHierID
     C                   KFLD                    KLink
     C                   KFLD                    KPrDate
     C                   KFLD                    KSeqNum
 
      ** Key List for Posting Reference
 
     C     KPostRef      KLIST
     C                   KFLD                    KRefID
     C                   KFLD                    KRefNum
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
     OREICSDD0  E            U_REICSD
     O                       IDSPTD
