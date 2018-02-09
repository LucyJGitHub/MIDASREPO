     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Determine a CM Child A/c Category')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100603 - Determine a Cash Management Child A/c Category    *
      *                                                               *
      *  Function:  This program determines a child account category  *
      *             for a cash management hierarchy link.             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. B07232             Date 01Aug05               *
      *                 CSD027             Date 09Dec05               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  B07232 - Account codes not 10 long.                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRECMHLL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        O_CCAT
 
      * If blank parent passed in,
      * then this link is the top of the hierarchy
 
     C     I_PBRC        IFEQ      *BLANK
     C*****I_PCUS        ANDEQ     *ZERO                                                      CSD027
     C     I_PCUS        ANDEQ     *BLANKS                                                    CSD027
     C     I_PCCY        ANDEQ     *BLANK
     C     I_PACD        ANDEQ     *ZERO
     C     I_PASN        ANDEQ     *ZERO
     C                   MOVEL     'T'           O_CCAT
     C                   ELSE
 
      * Access CM hierarchy link file (by parent)
 
     C                   MOVEL     I_HIER        CLHIER
     C                   MOVEL     I_CBRC        CLPBRC
     C                   MOVEL     I_CCUS        CLPCUS
     C                   MOVEL     I_CCCY        CLPCCY
     C                   MOVEL     I_CACD        CLPACD
     C                   MOVEL     I_CASN        CLPASN
 
     C     RECMHLK       CHAIN     RECMHLD0                           60        *
 
      * If child is not someone's parent, it is a sub-account.
      * Otherwise it is a level account.
 
     C     *in60         IFEQ      '1'
     C                   MOVEL     'S'           O_CCAT
     C                   ELSE
     C                   MOVEL     'L'           O_CCAT
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
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
     C                   PARM                    I_HIER            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        B07232
     C                   PARM                    I_CACD           10 0                        B07232
     C                   PARM                    I_CASN            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        B07232
     C                   PARM                    I_PACD           10 0                        B07232
     C                   PARM                    I_PASN            2 0
 
      * OUTPUTS
      * Child A/c Category
     C                   PARM                    O_CCAT            1
 
      * Key lists
 
     C     RECMHLK       KLIST
     C                   KFLD                    CLHIER
     C                   KFLD                    CLPBRC
     C                   KFLD                    CLPCUS
     C                   KFLD                    CLPCCY
     C                   KFLD                    CLPACD
     C                   KFLD                    CLPASN
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
