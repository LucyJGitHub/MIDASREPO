     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Forward Yield Curve')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMVFWDYLD - Midas Validate Forward YieldCurve                *
      *                                                               *
      *  Function:  Validation program that will validate Forward     *
      *             Yield Curve.                                      *
      *                                                               *
      *  Called By: MMLDNIVL2 - Midas MM Loans/deposits validation 2  *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9607            Date 23Dec05               *
      *                 CDL033  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE026 - Consumer Banking                                    *
      *  BUG9607 - Unable to input CF Floating Rate deal if CAS005    *
      *            is switched off                                    *
      *  CDL033 - Floating Rate CD Issued                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       50         Chain                                        *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     FFDDTSTL1  IF   E           K DISK
      ** DL Standing Data Deal Type/Subtype
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Yield Curves
     D SDYLDC        E DS                  EXTNAME(SDYLDCPD)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
      ** Option
     D POPTN           S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   DO
 
      ** -------------------------------
      ** If Forward Yield Curve is blank
      ** -------------------------------
 
     C     FWDYLD        IFEQ      *BLANKS
 
     C     KDEALS        CHAIN     FDDTSTL1                           50
 
      ** If not found, DBError
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     001           DBASE
     C     DELTYP        CAT(P)    DLSTYP        DBKEY
     C                   MOVEL     'FDDTSTL1'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     FSFYCM        IFEQ      'Y'
     C     FWDYLD        ANDEQ     *BLANKS
     C                   MOVEL     'LEL0529'     #MSGID
     C                   MOVEL     FWDYLD        #MSGDATA
     C                   MOVEL     'Error'       RTNCDE
     C                   LEAVE
     C                   ELSE
     C                   MOVE      *BLANKS       FWDYLD
     C                   ENDIF
 
      ** ----------------------------------------
      ** Else If Forward Yield Curve is not blank
      ** ----------------------------------------
 
     C                   ELSE
 
     C                   CALL      'AOYLDCR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FWDYLD        PPYLDC            5
     C     SDYLDC        PARM      SDYLDC        DSSDY
 
     C                   SELECT
 
      ** Case 1: No record found
     C                   WHEN      PRTCD = '*NRF   '
     C                   MOVEL     'LEL0535'     #MSGID
     C                   MOVE      FWDYLD        #MSGDATA
     C                   MOVEL     'Error'       RTNCDE
     C                   LEAVE
 
      ** Case 2: No selection
     C                   WHEN      PRTCD = '*NOSEL '
     C     KDEALS        CHAIN     FDDTSTL1                           50
     C     *IN50         IFEQ      *ON
     C                   Z-ADD     002           DBASE
     C     DELTYP        CAT(P)    DLSTYP        DBKEY
     C                   MOVEL     'FDDTSTL1'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      FSORFY        FWDYLD
     C     FWDYLD        IFNE      *BLANKS
 
     C     CAS005        IFEQ      'N'
     C                   CALL      'AOYLDCR0'
     C                   PARM      '*BLANKS'     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      FWDYLD        PPYLDC
     C     SDYLDC        PARM      SDYLDC        DSSDY
     C     PRTCD         IFEQ      '*NRF'
     C                   MOVEL     'LEL0535'     #MSGID
     C                   MOVE      FWDYLD        #MSGDATA
     C                   MOVE      'Error'       RTNCDE
     C                   LEAVE
     C                   ENDIF
      ** CAS005 = 'Y'
     C                   ELSE
     C     FSFYCM        IFEQ      'Y'
     C                   MOVEL     'LEL0529'     #MSGID
     C                   MOVE      FWDYLD        #MSGDATA
     C                   MOVE      'Error'       RTNCDE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Case 3: Valid input
     C                   WHEN      PRTCD = *BLANK
     C                   MOVE      PPYLDC        FWDYLD
 
     C                   ENDSL
 
     C**********         ENDIF                                                               BUG9607
 
     C     CAS005        IFEQ      'N'
 
      ** Error if Non Zero-coupon Yield Curve
 
     C     FSYLDT        IFNE      'Z'
     C                   MOVEL     'LEL0533'     #MSGID
     C                   MOVEL     FWDYLD        #MSGDATA
     C                   MOVE      'Error'       RTNCDE
     C                   LEAVE
     C                   ENDIF
 
     C     FSINTP        IFNE      'Y'
     C     FSINTP        ANDNE     'R'
     C                   MOVEL     'LEL0534'     #MSGID
     C                   MOVE      FWDYLD        #MSGDATA
     C                   MOVE      'Error'       RTNCDE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF                                                               BUG9607
                                                                                             BUG9607
     C                   ENDDO
 
     C                   SETON                                        LR
      *****************************************************************
      *                                                               *
      * Program Initialisation                                        *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    RTNCDE            7
     C                   PARM                    FWDYLD            5
     C                   PARM                    DELTYP            2
     C                   PARM                    DLSTYP            2
     C                   PARM                    CAS005            1
     C                   PARM                    #MSGID
     C                   PARM                    #MSGDATA
 
     C     KDEALS        KLIST
     C                   KFLD                    DELTYP
     C                   KFLD                    DLSTYP
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
** CPY@
(c) Finastra International Limited 2005
