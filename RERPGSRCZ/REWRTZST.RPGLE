     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Write to Zero-Balancing Stops files')         *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REWRTZST - Write to Zero-Balancing Stops Files               *
      *                                                               *
      *  Function:  This program is given link details and posting    *
      *             details and writes to files REZSTDPD and REZSTIPD.*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG28077           Date 26Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG28077 - Parent account code field was not updated to 10S. *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREZSTDPD  O    E             DISK    INFSR(*PSSR)
     FREZSTIPD  O    E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_XRFN          S             10    DIM(1000)
 
 
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
     C                   MOVEL     I_HIER        ZIHIER
      * Link ID
     C                   MOVEL     I_LINK        ZILINK
      * Processing Date
     C                   Z-ADD     BJRDNB        ZIPRCD
      * Stop Number
     C                   Z-ADD     I_NASN        ZISTPN
      * Extension File Ref. No.
     C                   MOVEL     I_XRFN(C)     ZIXRFN
 
     C                   WRITE     REZSTID0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write Detail records
      ********************************************************************
     C     WRT_DETAIL    BEGSR
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        ZDHIER
      * Link ID
     C                   MOVEL     I_LINK        ZDLINK
      * Processing Date
     C                   Z-ADD     BJRDNB        ZDPRCD
      * Stop Number
     C                   Z-ADD     I_NASN        ZDSTPN
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        ZDHISN
      * Child Account Branch Code
     C                   MOVEL     I_CBRC        ZDCBRC
      * Child Account Customer
     C                   MOVEL     I_CCUS        ZDCCUS
      * Child Account Currency
     C                   MOVEL     I_CCCY        ZDCCCY
      * Child Account A/c Code
     C                   MOVEL     I_CACD        ZDCACD
      * Child Account A/c Sequence
     C                   MOVEL     I_CASN        ZDCASN
      * Child A/c Category
     C                   MOVEL     I_CCAT        ZDCCAT
      * Parent Account Branch Code
     C                   MOVEL     I_PBRC        ZDPBRC
      * Parent Account Customer
     C                   MOVEL     I_PCUS        ZDPCUS
      * Parent Account Currency
     C                   MOVEL     I_PCCY        ZDPCCY
      * Parent Account A/c Code
     C**********         MOVEL     I_PACD        ZDPACD                                     BUG28077
     C                   MOVEL     I_PACD        ZDPA10                                     BUG28077
      * Parent Account A/c Sequence
     C                   MOVEL     I_PASN        ZDPASN
      * Maximum Debit Value in a Day
     C                   Z-ADD     I_MDVD        ZDMDVD
      * Today's Total Debit Value
     C                   Z-ADD     I_TVDR        ZDTVDR
      * Maximum Debit Count in a Day
     C                   Z-ADD     I_MDCD        ZDMDCD
      * Today's Total Debit Count
     C                   Z-ADD     I_TCDR        ZDTCDR
      * Released
     C                   MOVEL     'N'           ZDRELD
      * Deleted
     C                   MOVEL     'N'           ZDDELD
 
     C                   WRITE     REZSTDD0
 
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
     C                   PARM                    I_PACD           10 0                        CGL029
     C                   PARM                    I_PASN            2 0
      * Next Available Stop No.
     C                   PARM                    I_NASN            2 0
      * Maximum Debit Value in a Day
      * Today's Total Debit Value
      * Maximum Debit Count in a Day
      * Today's Total Debit Count
     C                   PARM                    I_MDVD           15 0
     C                   PARM                    I_TVDR           15 0
     C                   PARM                    I_MDCD            3 0
     C                   PARM                    I_TCDR            3 0
 
      * Extension Reference Numbers
     C                   PARM                    I_XRFN
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
