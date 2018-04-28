     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Message Type and Message Tag Access Obj')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOWLMTR0 - Message Type and Message Tag Access Object        *
      *                                                               *
      *  Function:  This program accepts message type as input to see *
      *             if this is included or excluded from the watch    *
      *             list checking.                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDWLMTL0  IF   E           K DISK
      ** Message Types for Watch List Checking Details File
 
     FSDWMTGL0  IF   E           K DISK
      ** Message Tags File
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D PMTYP           S              3A
     D PMTAG           S              5A
     D WMTYP           S              3A
     D WMTAG           S              3A
     D WINEX           S              1A
     D WCTR            S              1S 0
     D X               S              1S 0
 
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
 
     C                   IF        POPTN = '*MTYP'
     C                   EXSR      SRMTYP
     C                   ELSE
     C                   EXSR      SRMTAG
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMTYP - Access by Message Type                              *
      *                                                               *
      *****************************************************************
 
     C     SRMTYP        BEGSR
 
     C                   EVAL      WMTYP = PMTYP
     C                   EVAL      WINEX = *BLANKS
     C                   EVAL      WCTR = 1
 
     C     WMTYP         CHAIN     SDWLMTL0                           75
 
     C                   DOW       WINEX = *BLANKS
 
     C                   IF        *IN75 = *OFF
     C                   EVAL      WINEX = W2INEX
     C                   ELSE
 
     C                   IF        WCTR = 1
     C                   MOVE      '*'           WMTYP
     C                   ELSE
     C                   IF        WCTR = 2
     C                   MOVE      '**'          WMTYP
     C                   ELSE
     C                   MOVE      '***'         WMTYP
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WCTR > 3
     C                   MOVE      'E'           WINEX
     C                   ELSE
     C     WMTYP         CHAIN     SDWLMTL0                           75
     C                   ENDIF
 
     C                   EVAL      WCTR = WCTR + 1
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WINEX = 'I'
     C                   EVAL      PRTCD = *BLANKS
     C                   ELSE
     C                   EVAL      PRTCD = '*NRF   '
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMTAG - Access by Message Tag                               *
      *                                                               *
      *****************************************************************
 
     C     SRMTAG        BEGSR
 
     C                   EVAL      PRTCD = *BLANKS
 
     C     ':'           SCAN      PMTAG:2       X
 
     C                   EVAL      WMTAG = %SUBST(PMTAG:2:X-2)
 
     C     WMTAG         CHAIN     SDWMTGL0                           75
 
     C                   IF        *IN75 = *ON
     C                   MOVE      '*'           WMTAG
     C     WMTAG         CHAIN     SDWMTGL0                           75
     C                   IF        *IN75 = *ON
     C                   EVAL      PRTCD = '*NRF   '
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    POPTN
     C                   PARM                    PMTYP
     C                   PARM                    PMTAG
 
     C                   ENDSR
 
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
