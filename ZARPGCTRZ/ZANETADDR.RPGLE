     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Get network and address information')
      *****************************************************************
      *                                                               *
      *  Midas - Common functions module                              *
      *                                                               *
      *  ZANETADDR - Determine Network and Addresses.                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP003  *CREATE    Date 03Jul98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array used to move right Swift Id.
     D ROU             S              1    DIM(12)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   MOVE      *BLANKS       WNWSN            20
     C                   MOVE      *BLANKS       WNWDS            22
     C                   MOVE      *BLANKS       WNWRK             6
     C                   MOVE      *BLANKS       WERRC             1
     C                   MOVE      *BLANKS       WSRNM            20
     C                   MOVE      *BLANKS       WSRTN            10
     C                   MOVE      *BLANKS       WDRNM            20
     C                   MOVE      *BLANKS       WDRTN            10
      *
     C     DDTDTP        IFEQ      'TP'
     C                   MOVEL     DDDELT        WSNDR             6
     C                   MOVEL     DDDELT        WDEST             6
     C                   ELSE
     C                   MOVEL     DDDELF        WSNDR
     C                   MOVEL     DDDELF        WDEST
     C                   END
     C                   MOVE      *BLANKS       WSCSD            12
     C                   MOVE      DDSMTH        WSETP             2
      *
      *
     C                   CALL      'ZM1100'                             50
     C                   PARM                    WSNDR
     C                   PARM                    WSCSD
     C                   PARM                    WDEST
     C                   PARM                    WSETP
     C                   PARM                    WNWSN
     C                   PARM                    WNWDS
     C                   PARM                    WNWRK
     C                   PARM                    WERRC
     C                   PARM                    WSRNM
     C                   PARM                    WSRTN
     C                   PARM                    WDRNM
     C                   PARM                    WDRTN
      *
     C     WSNDR         IFNE      *BLANKS
     C     WDEST         ANDNE     *BLANKS
      *
     C     *IN50         IFEQ      '1'
     C     WERRC         OREQ      'S'
     C     WERRC         OREQ      'D'
     C     WNWRK         OREQ      'UNROUT'
     C                   MOVE      'N'           WWGME             1
     C                   MOVEL     *BLANKS       WWROU             6
     C                   MOVEL     '  UNRO'      WKROT             6
     C                   MOVEL     WKROT         WWROT            12
     C                   MOVE      'UTABLE'      WWROT
     C                   ELSE
      *
     C                   MOVE      'Y'           WWGME
     C                   MOVEL     WNWRK         WWROU
     C                   MOVEA     WNWDS         ROU
     C                   Z-ADD     1             J                 2 0
     C     ' '           LOOKUP    ROU(J)                                 85
     C     *IN85         IFEQ      '0'                                          not found.
     C                   MOVEL     WNWDS         WWROT
     C                   ELSE                                                   found.
     C     14            SUB       J             K                 2 0
     C                   MOVEA     *ALL' '       ROU
     C                   MOVEA     WNWDS         ROU(K)
     C                   MOVEA     ROU           WWROT
     C                   END
     C                   END
      *
     C                   ENDIF
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Trade type
     C                   PARM                    DDTDTP            2
      * Deliver To
     C                   PARM                    DDDELT           10
      * Deliver From
     C                   PARM                    DDDELF           10
      * Settlement method
     C                   PARM                    DDSMTH            2
     C                   PARM                    WWGME
     C                   PARM                    WWROT
     C                   PARM                    WWROU
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
