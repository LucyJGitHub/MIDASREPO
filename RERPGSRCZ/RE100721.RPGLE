     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Rev Sweeping/Target Bal Shadow Posting')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100721  - Reverse Sweeping/Target Balancing Shadow Posting *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
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
      * SRProcess - Subroutine to update the cleared balances on file *
      * SRAudit   - Subroutine to Output Audit Report                 *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** RE Reverse Sweeping/Target Balancing - Details Not Shadow Posted
     FRERSTDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** RE Reverse Sweeping/Target Balancing - Items
     FRERSTIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** GL Postings in Transit
     FGLPSTTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
 
      ** RE Reverse Sweeping/Target Balancing Shadow Posting - Audit
     FRE100721AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      ** GL Postings in Transit
     D I_ENTRY       E DS                  EXTNAME(GLPSTTPD)
     D                                     PREFIX(E_)
 
 
      ** File Information Data Structure for RE100721AU
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
 
      ** Read all records in LF/RERSTDL1
 
     C     *LOVAL        SETLL     RERSTDL1
     C                   READ      RERSTDL1                               89
 
     C                   DOW       *IN89 = *Off
 
      ** Set up Key Fields
 
     C                   EVAL      KHierID = RDHIER
     C                   EVAL      KLink   = RDLINK
     C                   EVAL      KPrDate = RDPRCD
     C                   EVAL      KSeqNum = RDSNUM
 
     C     KRevSwp       SETLL     RERSTIL0
     C     KRevSwp       READE     RERSTIL0                               88
 
      ** Retrieve the posting record
 
     C                   DOW       *IN88 = *Off
     C                   EVAL      KRefID  = 'ZS '
     C                   EVAL      KRefNum = RIXRFN
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
 
     C     KRevSwp       READE     RERSTIL0                               88
     C                   ENDDO
 
      ** Update RERSTDL1 record
 
     C                   EVAL      RDSPTD = 'Y'
     C                   EXCEPT    U_RERSTD
 
      ** Commit updates
 
     C                   COMMIT
 
      ** Increment counter for the no. of records read
 
     C                   EVAL      WkCnt1 = WkCnt1 + 1
 
     C                   READ      RERSTDL1                               89
     C                   ENDDO
 
      ** Produce the Audit Report
 
     C                   EVAL      RCount1 = WkCnt1
     C                   EVAL      RCount2 = WkCnt2
 
     C                   EXSR      SRAudit
 
     C                   EVAL      *INLR = *On
 
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
 
     C     KRevSwp       KLIST
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
     ORERSTDD0  E            U_RERSTD
     O                       RDSPTD
