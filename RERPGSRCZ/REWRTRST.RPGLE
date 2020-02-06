     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Write to Rev.Sweeeping/Target Bal. files')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  REWRTRST - Write to Reverse Sweeeping/Target Balancing Files *
      *                                                               *
      *  Function:  This program is given link details and posting    *
      *             details and writes to files RERSTDPD and RERSTIPD.*
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRERSTDPD  O    E             DISK    INFSR(*PSSR)
     FRERSTIPD  O    E             DISK    INFSR(*PSSR)
 
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
     C                   MOVEL     I_HIER        RIHIER
      * Link ID
     C                   MOVEL     I_LINK        RILINK
      * Processing Date
     C                   Z-ADD     BJRDNB        RIPRCD
      * Sequence Number
     C                   MOVEL     I_NASN        RISNUM
      * Extension File Ref. No.
     C                   MOVEL     I_XRFN(C)     RIXRFN
 
     C                   WRITE     RERSTID0
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write Detail records
      ********************************************************************
     C     WRT_DETAIL    BEGSR
 
      * Hierarchy ID
     C                   MOVEL     I_HIER        RDHIER
      * Link ID
     C                   MOVEL     I_LINK        RDLINK
      * Processing Date
     C                   Z-ADD     BJRDNB        RDPRCD
      * Sequence Number
     C                   MOVEL     I_NASN        RDSNUM
      * Hierarchy Shortname
     C                   MOVEL     I_HISN        RDHISN
      * Child Account Branch Code
     C                   MOVEL     I_CBRC        RDCBRC
      * Child Account Customer
     C                   MOVEL     I_CCUS        RDCCUS
      * Child Account Currency
     C                   MOVEL     I_CCCY        RDCCCY
      * Child Account A/c Code
     C                   MOVEL     I_CACD        RDCACD
      * Child Account A/c Sequence
     C                   MOVEL     I_CASN        RDCASN
      * Child A/c Category
     C                   MOVEL     I_CCAT        RDCCAT
      * Parent Account Branch Code
     C                   MOVEL     I_PBRC        RDPBRC
      * Parent Account Customer
     C                   MOVEL     I_PCUS        RDPCUS
      * Parent Account Currency
     C                   MOVEL     I_PCCY        RDPCCY
      * Parent Account A/c Code
     C                   MOVEL     I_PACD        RDPACD
      * Parent Account A/c Sequence
     C                   MOVEL     I_PASN        RDPASN
      * Shadow Posted
     C                   MOVEL     'N'           RDSPTD
 
     C                   WRITE     RERSTDD0
 
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
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
 
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
