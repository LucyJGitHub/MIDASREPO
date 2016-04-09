     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Further Settle Instructions update')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  ZAFSETIUPD - Further Settlement Instructions update          *
      *                                                               *
      *  Function:  This program updates multiple settlement accounts *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CDL018  *CREATE    Date 03Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *                                                               *
      *****************************************************************
 
     FDLFSACL1  UF A E           K DISK    COMMIT
      ** Deals Further Settlement Accounts
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
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
 
     D NwFSInsFmt    E DS                  EXTNAME(DLFSACPD)
      ** Further Settlement Instructions in File Format
     D  FSREC                  7    519
     D  FSPAY                520   1032
 
     D #FRECF        E DS                  EXTNAME(SDFSFRPD)
      ** File - Receive Further Settlement Instructions
 
     D #FPAYF        E DS                  EXTNAME(SDFSFPPD)
      ** File - Payment Further Settlement Instructions
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Access Further Settlement Instructions file
 
     C                   MOVE      ##DLNO        PDLNO             6 0
     C     PDLNO         CHAIN     DLFSACL1                           90
 
      ** Insert Further Settlement Instructions
 
     C     *IN90         IFEQ      *ON
     C                   EXSR      SRINS
 
      ** Update Further Settlement Instructions
 
     C                   ELSE
 
     C     FLRMAC        IFNE      'Y'
     C     FLPMAC        ANDNE     'Y'
     C                   EXSR      SRDLT
     C                   ELSE
     C                   EXSR      SRUPD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Exit program
 
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINS - Insert Further Settlement Instructions                *
      *                                                               *
      *****************************************************************
     C     SRINS         BEGSR
 
      ** Deal Number
 
     C                   MOVE      ##DLNO        DLNO
 
      ** Receipt Details
 
     C                   MOVEL     #FRECF        FSREC
 
      ** Payment Details
 
     C                   MOVEL     #FPAYF        FSPAY
 
      ** Write to file
 
     C                   WRITE     DLFSACD0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPD - Update Further Settlement Instructions                *
      *                                                               *
      *****************************************************************
     C     SRUPD         BEGSR
 
      ** Receipt Details
 
     C                   MOVEL     #FRECF        FSREC
 
      ** Payment Details
 
     C                   MOVEL     #FPAYF        FSPAY
 
      ** Update file
 
     C                   UPDATE    DLFSACD0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLT - Delete Further Settlement Instructions                *
      *                                                               *
      *****************************************************************
     C     SRDLT         BEGSR
 
      ** Delete file
 
     C                   DELETE    DLFSACD0
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
 
      ** INPUTS
      ** Return Code
     C                   PARM                    ##RTCD            7
 
      ** Deal Number
     C                   PARM                    ##DLNO            6
 
      ** Receipt - More Accounts
     C                   PARM                    FLRMAC            1
 
      ** Payment - More Accounts
     C                   PARM                    FLPMAC            1
 
      ** Payment - Further Settle instructions - File format
     C                   PARM                    #FPAYF
 
      ** Receive - Further Settle instructions - File format
     C                   PARM                    #FRECF
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
