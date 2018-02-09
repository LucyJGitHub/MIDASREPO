     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Write to IC Zero Balancing/Sweeping files')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REWRTICS - Write to IC Zero Balancing/Sweeping Files         *
      *                                                               *
      *  Function:  This program is given destination a/c details and *
      *             posting details and writes to files REICSDPD and  *
      *             REICSIPD.                                         *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 214360             Date 03Feb03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  214360 - Cash Management Deferred Posting                    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FCBAICDL1  IF   E           K DISK    INFSR(*PSSR)                         214360
     FREICSDPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     FREICSIPD  O    E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_XRFN          S             10    DIM(6)
                                                                                              CCB020
      ** Work Variable in calling CBC001001                                                   CCB020
     D COBST           S              4                                                       CCB020
 
 
      ***MPHAS*Data-Area***********************************************                214360 CCB020
     D***MPHAS**         DS             1                                              214360 CCB020
     D****PHASE*                 1      1                                              214360 CCB020
                                                                                214360
                                                                                214360
     D REICSD        E DS                  EXTNAME(REICSDPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Write item records
 
     C                   Z-ADD     1             C                 2 0
     C     I_XRFN(C)     DOUEQ     *BLANK
     C                   EXSR      WRT_ITEM
     C                   ADD       1             C
     C                   ENDDO
 
      * Write detail record
 
     C                   EXSR      WRT_DETAIL
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Write Item records
      ********************************************************************
     C     WRT_ITEM      BEGSR
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        IIHIER
      * Link ID
     C                   MOVEL     I_LINK        IILINK
      * Processing Date
     C                   Z-ADD     BJRDNB        IIPRCD
      * Sequence Number
     C                   MOVEL     I_NASN        IISNUM
      * Extension File Ref. No.
     C                   MOVEL     I_XRFN(C)     IIXRFN
 
     C                   WRITE     REICSID0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write Detail records
      ********************************************************************
     C     WRT_DETAIL    BEGSR
 
     C                   CLEAR                   REICSD
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        IDHIER
      * Link ID
     C                   MOVEL     I_LINK        IDLINK
      * Processing Date
     C                   Z-ADD     BJRDNB        IDPRCD
      * Sequence Number
     C                   MOVEL     I_NASN        IDSNUM
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        IDHISN
      * Child Account Branch Code
     C                   MOVEL     I_CBRC        IDCBRC
      * Child Account Customer
     C                   MOVEL     I_CCUS        IDCCUS
      * Child Account Currency
     C                   MOVEL     I_CCCY        IDCCCY
      * Child Account A/c Code
     C                   MOVEL     I_CACD        IDCACD
      * Child Account A/c Sequence
     C                   MOVEL     I_CASN        IDCASN
      * Parent Account Branch Code
     C                   MOVEL     I_PBRC        IDPBRC
      * Parent Account Customer
     C                   MOVEL     I_PCUS        IDPCUS
      * Parent Account Currency
     C                   MOVEL     I_PCCY        IDPCCY
      * Parent Account A/c Code
     C                   MOVEL     I_PACD        IDPACD
      * Parent Account A/c Sequence
     C                   MOVEL     I_PASN        IDPASN
      * Sweep Type
     C                   MOVEL     I_STYP        IDSTYP
      * Value Date
     C                   MOVEL     I_VALD        IDVALD
 
      * If Top
 
     C     I_CCAT        IFEQ      'T'
      * Destination
     C                   MOVEL     I_DEST        IDDEST
      * Destination Type
     C                   MOVEL     I_DSTT        IDDSTT
      * Sender's Correspondent
     C                   MOVEL     I_SNDC        IDSNDC
      * Receiver's Correspondent
     C                   MOVEL     I_RCVC        IDRCVC
      * MT202 Cover Message Required
     C                   MOVEL     I_MCMR        IDMCMR
      * External Narrative
     C                   MOVEL     I_PNAR        IDENAR
      * Top Account Narrative
     C                   MOVEL     I_CNAR        IDTNAR
      * Charges
      * Charges Account
      * Charges Amount
      * Instruction Code
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     I_CHG1        IDCHGR
     C                   MOVEL     I_CAC1        IDCACT
     C                   Z-ADD     I_CAM1        IDCAMT
     C                   MOVEL     I_ICD1        IDINCD
     C                   ELSE
     C                   MOVEL     I_CHG3        IDCHGR
     C                   MOVEL     I_CAC3        IDCACT
     C                   Z-ADD     I_CAM3        IDCAMT
     C                   MOVEL     I_ICD3        IDINCD
     C                   ENDIF
      * MT103 Bank Operation Code
     C                   MOVEL     I_BOCD        IDBOCD
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   MOVEL     I_EXA1        IDEXA1
     C                   MOVEL     I_EXA2        IDEXA2
     C                   MOVEL     I_EXA3        IDEXA3
     C                   MOVEL     I_EXA4        IDEXA4
     C                   MOVEL     I_EXA5        IDEXA5
      * Swift Amount
     C                   Z-ADD     I_PSTA        IDSWFA
 
     C                   ENDIF
      * Top/Sweep
     C     I_CADC        IFEQ      'C'
     C                   MOVEL     'T'           IDTPSW
     C                   ELSE
     C                   MOVEL     'S'           IDTPSW
     C                   ENDIF
      * Shadow Posted
     C                   MOVEL     I_SPTD        IDSPTD
      * Message Produced
     C                   MOVEL     'N'           IDMSGP
      * Message Time
     C                   Z-ADD     *ZERO         IDMSGT
      * Matched Y/N
     C     I_SMSR        IFNE      *BLANK
     C                   MOVEL     'Y'           IDMTYN
     C                   ELSE
     C     I_CCAT        IFEQ      'T'
     C     I_CADC        ANDEQ     'C'
     C                   MOVEL     'N'           IDMTYN
     C                   ELSE
     C                   MOVEL     'Y'           IDMTYN
     C                   ENDIF
     C                   ENDIF
      * Deleted
     C                   MOVEL     'N'           IDDELD
      * Outgoing Message SWIFT Refer
     C                   MOVEL     *BLANK        IDOMSR
      * Incoming Message SWIFT Refer
      * Incoming Message Input Refer
     C                   MOVEL     I_SMSR        IDSMSR                         TET
     C                   MOVEL     I_SMIR        IDSMIR                         TET
      * Sender
     C                   MOVEL     I_SNDR        IDSNDR                         TET
      * Incoming Message Amount
     C                   Z-ADD     I_SAMT        IDAMNT                         TET
      * Reply MT103 Reference
      * Reply MT103 Amount
      * Reply MT103 Action
     C                   MOVEL     I_R3RF        IDR3RF                         TET
     C                   Z-ADD     I_R3AM        IDR3AM                         TET
     C                   MOVEL     I_R3AC        IDR3AC                         TET
 
     C                   WRITE     REICSDD0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD           10 0                        CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD           10 0
     C                   PARM                    I_PASN            2 0
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM                    I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_DEST           18
     C                   PARM                    I_DSTT            1
     C                   PARM                    I_SNDC            2
     C                   PARM                    I_RCVC           11
     C                   PARM                    I_MCMR            1
     C                   PARM                    I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM                    I_CHG1            3
     C**********         PARM                    I_CAC1           18                          CGL029
     C                   PARM                    I_CAC1           24                          CGL029
     C                   PARM                    I_CAM1           15 0
     C                   PARM                    I_ICD1            4
     C                   PARM                    I_CHG3            3
     C**********         PARM                    I_CAC3           18                          CGL029
     C                   PARM                    I_CAC3           24                          CGL029
     C                   PARM                    I_CAM3           15 0
     C                   PARM                    I_ICD3            4
     C                   PARM                    I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM                    I_EXA1           35
     C                   PARM                    I_EXA2           35
     C                   PARM                    I_EXA3           35
     C                   PARM                    I_EXA4           35
     C                   PARM                    I_EXA5           35
      * Shadow Posted
     C                   PARM                    I_SPTD            1
      * Incoming Msg SWIFT Reference
     C                   PARM                    I_SMSR           16            TET
     C                   PARM                    I_SMIR           28            TET
      * Incoming Msg Sender and Amount
     C                   PARM                    I_SNDR           11            TET
     C                   PARM                    I_SAMT           15 0          TET
      * Reply MT103 Reference
      * Reply MT103 Amount
      * Reply MT103 Action
     C                   PARM                    I_R3RF           16
     C                   PARM                    I_R3AM           15 0
     C                   PARM                    I_R3AC            7
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
     C                   PARM                    I_PSTA           13 0
     C                   PARM                    I_CADC            1
     C                   PARM                    I_VALD            5 0
     C                   PARM                    I_SDES           30
     C                   PARM                    I_STYP            1
 
      * Extension Reference Numbers
     C                   PARM                    I_XRFN
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                214360
      ***Read*MPHAS*data-area******************************************                214360 CCB020
                                                                                214360
     C******DTAARA       DEFINE                  MPHAS                                 214360 CCB020
     C**********         IN        MPHAS                                               214360 CCB020
                                                                                              CCB020
      ** Call program CBC001001 to check if system is in COB or IC                            CCB020
      ** If the return value is *YES, system is in COB                                        CCB020
                                                                                              CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM                    COBST                                        CCB020
                                                                                214360
      * Get following run date                                                  214360
                                                                                214360
     C*****PHASE         IFNE      'A'                                                 214360 CCB020
     C*****PHASE         ANDNE     'B'                                                 214360 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C                   MOVEL     'A.COB '      ABACOB                         214360
     C     ABACOB        CHAIN     @AICDF1                            99        214360
     C     *in99         IFEQ      '1'                                          214360
     C                   EVAL      X_ERMS = 'NO RECORD FOUND ON CBAICDL1'       214360
     C                   EXSR      *PSSR                                        214360
     C                   ENDIF                                                  214360
     C                   Z-ADD     ABDBRN        BJRDNB                         214360
     C                   ENDIF                                                  214360
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
