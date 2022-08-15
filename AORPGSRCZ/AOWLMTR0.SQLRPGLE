     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
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
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     F*SDWLMTL0* IF   E           K DISK                                                    MD058085
      ** Message Types for Watch List Checking Details File

     F*SDWMTGL0* IF   E           K DISK                                                    MD058085
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

     D SDWLMT        E DS                  EXTNAME(SDWLTJW0)                                MD058085
     D SDWMTG        E DS                  EXTNAME(SDWMTJW0)                                MD058085
     D W3MODE        E                     EXTFLD(W2MODE)                                   MD058082
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

     C*****WMTYP         CHAIN     SDWLMTL0                           75                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDWLMT                                                                        MD058085
     C+ from SDWLTJW0                                                                       MD058085
     C+ where W2MTYP = :WMTYP                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       75                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        75                    MD058085
     C                   ENDIF                                                              MD058085

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
     C*****WMTYP         CHAIN     SDWLMTL0                           75                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDWLMT                                                                        MD058085
     C+ from SDWLTJW0                                                                       MD058085
     C+ where W2MTYP = :WMTYP                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       75                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        75                    MD058085
     C                   ENDIF                                                              MD058085
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

     C*****WMTAG         CHAIN     SDWMTGL0                           75                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDWMTG                                                                        MD058085
     C+ from SDWMTJW0                                                                       MD058085
     C+ where W2MSGT = :WMTAG                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       75                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        75                    MD058085
     C                   ENDIF                                                              MD058085

     C                   IF        *IN75 = *ON
     C                   MOVE      '*'           WMTAG
     C*****WMTAG         CHAIN     SDWMTGL0                           75                    MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDWMTG                                                                        MD058085
     C+ from SDWMTJW0                                                                       MD058085
     C+ where W2MSGT = :WMTAG                                                               MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       75                    MD058085
     C                   If        SQLCODE <> 0                                             MD058085
     C                   SETON                                        75                    MD058085
     C                   ENDIF                                                              MD058085
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
(c) Finastra International Limited 2002
