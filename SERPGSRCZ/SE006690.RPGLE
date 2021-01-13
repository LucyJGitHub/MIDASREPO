     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE EU Customer Position update for trans.')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE006690 - EU TAX Customer Position update for a trade or    *
      *              depot movement                                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *    This program adds a new record on ETCPOSND for a           *
      *    transaction dated after a backvaluation                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236125             Date 22Sep05               *
      *                 235546  *CREATE    Date 27Jul05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  236125 - Program not coping if trade is not there            *
      *  235546 - EU Tax backvaluations                               *
      *                                                               *
      *****************************************************************
 
     FSECTY     IF   E           K DISK    PREFIX(SEC_)
     FDPTMVDL1  IF   E           K DISK    PREFIX(D_) USROPN
     FTRADS     IF   E           K DISK    USROPN COMMIT
 
      *****************************************************************
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
 
      ** Include the SE standard declares
     D/COPY SECPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
 
     D Security      E DS                  EXTNAME(SECTYD) PREFIX(SEC_)
     D ValidTrade    E DS                  EXTNAME(SEVTRADPD)
     D T_REC         E                     EXTFLD(RECI)
     D ValidDpmv     E DS                  EXTNAME(SEVDPMVPD) PREFIX(D_)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D Actn_Code       S              1A
     D Tr_Type         S              1A
     D KSesn           S                   LIKE(TDSS)
     D KBrca           S                   LIKE(TDBA)
     D KCust           S                   LIKE(TCNR)
     D KDate           S                   LIKE(TDVD)
     D TDate           S                   LIKE(TDVD)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C* Trade records
 
     C                   IF        PType = 'T'
 
     C                   IF        WOpenT <> 'Y'
     C                   OPEN      TRADS
     C                   MOVEL     'Y'           WOpenT            1
     C                   ENDIF
 
     C     PTRef         CHAIN     TRADS                              89
     C     *IN89         IFEQ      *OFF                                                       236125
     C                   MOVEL     TDBA          KBrca
     C                   MOVEL     TDSS          KSesn
     C**********         Z-ADD     TCNR          KCust                                       CSD027A
     C                   EVAL      KCust = TCNR                                              CSD027A
     C                   EVAL      TDate = TDVD
     C                   ENDIF                                                                236125
     C                   ENDIF
 
     C* Depot Movement records
 
     C                   IF        PType = 'D'
 
     C                   IF        WOpenD <> 'Y'
     C                   OPEN      DPTMVDL1
     C                   MOVEL     'Y'           WOpenD            1
     C                   ENDIF
 
     C     PTRef         CHAIN     DPTMVDL1                           89
 
     C     *IN89         IFEQ      *OFF                                                       236125
     C                   IF        D_DPMV = 'WI'
     C                   MOVEL     D_DPBA        KBrca
     C                   MOVEL     D_DPSS        KSesn
     C**********         Z-ADD     D_DPBN        KCust                                       CSD027A
     C                   EVAL      KCust = D_DPBN                                            CSD027A
     C                   EVAL      TDate = D_DPMD
     C                   ENDIF
 
     C                   IF        D_DPMV = 'WO'
     C                   MOVEL     D_DPBA        KBrca
     C                   MOVEL     D_DPSS        KSesn
     C**********         Z-ADD     D_DPBN        KCust                                       CSD027A
     C                   EVAL      KCust = D_DPBN                                            CSD027A
     C                   EVAL      TDate = D_DPDO
     C                   ENDIF
     C                   ENDIF                                                                236125
     C                   ENDIF
 
     C     *IN89         IFEQ      *OFF                                                       236125
     C                   EXSR      SrSecty
 
     C                   EVAL      Actn_Code = 'I'
     C                   CALL      'SEETCPUPD'
     C                   PARM                    RetCodeIn
     C                   PARM                    Actn_Code
     C                   PARM      PType         Tr_Type
     C                   PARM                    ValidTrade
     C                   PARM                    ValidDpmv
     C                   PARM                    Security
     C                   ENDIF                                                                236125
 
     C                   SETON                                        LR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRSecty  - Access security details                            *
      *                                                               *
      *****************************************************************
     C     SRSecty       BEGSR
 
     C     KSesn         CHAIN     SECTY
 
     C                   IF        NOT%FOUND(SECTY)
     C                   EVAL      DBKEY = KSesn
     C                   EVAL      DBFILE = 'SECTYD'
     C                   EVAL      DBASE = 7
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PType             1
     C                   PARM                    PTRef             6
 
      ** Get Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 1
     C                   EXSR      *PSSR
     C                   END
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2005
