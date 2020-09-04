     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD055264
/*STD *  RPGSQLMOD                                                    *                     MD055264
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD055264
/*EXI *  TEXT('Midas AO Midas help reference access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOHELPR0 - Midas Help Reference Access Object                *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD055264           Date 31Mar20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC021             Date 15Dec03               *
      *                 CPK016  *CREATE    Date 22Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055264 - Deliverable Data Split for Help Text              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC021 - Changes to underlying Physical and logical files    *
      *           need to be reflected                                *
      *  CPK016 - Help processing infrastructure for Midas Webfacing. *
      *                                                               *
      *****************************************************************

      ** Help references file
     F*SCHELPL1* IF   E           K DISK    INFSR(*PSSR)                                    MD055264
     F**********                           USROPN                                           MD055264
     FSCAHLPL1  IF   E           K DISK    INFSR(*PSSR)                                     MD055264
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

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** Program, procedure and module names for parameters
      ** ==================================================

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
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

      ** Business Entity Identifier file
     D*SCHELP***     E DS                  EXTNAME(SCHELPPD)                                MD055264
     D SCHELP        E DS                  EXTNAME(SCHLPJW0)                                MD055264

      ** External Data structure to hold the outgoing record format
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D PRetCode        S              7A
     D POption         S              7A
     D****HelpRef         S            100A                                                   CSC021
     D****HelpTag         S             20A                                                   CSC021
     D HelpRef         S            200A                                                      CSC021
     D HelpTag         S            600A                                                      CSC021

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

      ** Access Option *SAME input

     C                   IF        PRetCode = '*SAME  '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
     C                   GOTO      TSkip
     C                   ENDIF

      ** Initialise Error Indicators

     C                   MOVEA     '0000000000'  *IN(90)

      ** First Call - Open File

     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C**********         OPEN      SCHELPL1                             91                  MD055264
     C                   IF        *IN91 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF

      ** Last call - close file and terminate program

     C                   IF        POption = '*FREE  '
     C**********         CLOSE     SCHELPL1                             92                  MD055264
     C                   IF        *IN92 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   GOTO      TSkip
     C                   ENDIF

      ** Caller request for first record

     C                   IF        POption = '*FIRST '
     C******LOVAL        SETLL     SCHELPL1                           9390                  MD055264
     C                   IF        *IN90 = *ON OR *IN93 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   EVAL      POption = '*NEXT  '
     C                   ENDIF

      ** Caller request for next record

     C                   IF        POption = '*NEXT  '
     C**********         READ      SCHELPL1                             9094                MD055264
     C                   IF        *IN90 = *ON OR *IN94 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF

      ** Caller request for last record

     C                   IF        POption = '*LAST  '
     C******HIVAL        SETGT     SCHELPL1                             90                  MD055264
     C                   IF        *IN90 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   EVAL      POption = '*PREV  '
     C                   ENDIF

      ** Caller request for previous record

     C                   IF        POption = '*PREV  '
     C**********         READP     SCHELPL1                             9094                MD055264
     C                   IF        *IN90 = *ON OR *IN94 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF

      ** Caller requests record indicated by key

     C**********         IF        POption = '*KEY   ' OR POption = '*VERIFY'               MD055264
     C                   IF        POption = '*KEY1  ' OR POption = '*VERIFY'               MD055264
     C                             or POption = '*KEY2  '                                   MD055264
     C                   IF        HelpRef  = *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   IF        POption = '*KEY1  '                                      MD055264
     C     HelpRef       CHAIN     SCAHLPL1                           9590                  MD055264
     C                   ELSE                                                               MD055264
     C*****HelpRef       CHAIN     SCHELPL1                           9590                  MD055264
     C/EXEC SQL                                                                             MD055264
     C+ SELECT *                                                                            MD055264
     C+ into :SCHELP                                                                        MD055264
     C+ from SCHLPJW0                                                                       MD055264
     C+ where HPJSP = :HelpRef                                                              MD055264
     C/END-EXEC                                                                             MD055264
     C                   SETOFF                                       9590                  MD055264
     C                   If        SQLCODE = 100                                            MD055264
     C                   SETON                                        95                    MD055264
     C                   ENDIF                                                              MD055264
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD055264
     C                   SETON                                        90                    MD055264
     C                   ENDIF                                                              MD055264
                                                                                            MD055264
     C                   ENDIF                                                              MD055264
                                                                                            MD055264
     C                   IF        *IN90 = *ON OR *IN95 = *ON
     C                   GOTO      TSkip
     C                   ENDIF
     C                   ENDIF

     C                   IF        POption <> '*KEY   ' AND
     C                             POption <> '*KEY1  ' AND                                 MD055264
     C                             POption <> '*KEY2  ' AND                                 MD055264
     C                             POption <> '*NEXT  ' AND
     C                             POption <> '*PREV  ' AND
     C                             POption <> '*VERIFY' AND
     C                             POption <> '*FREE  '
     C                   EVAL      *IN96 = *ON
     C                   ENDIF

     C     TSKip         TAG

     C                   EVAL      PRetCode = *BLANKS

     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PRetCode = '*ERROR '

     C                   WHEN      *IN91 = *ON
     C                   EVAL      PRetCode = '*OPEN  '

     C                   WHEN      *IN92 = *ON
     C                   EVAL      PRetCode = '*CLOSE '

     C                   WHEN      *IN93 = *ON
     C                   EVAL      PRetCode = '*EMPTY '

     C                   WHEN      *IN94 = *ON
     C                   EVAL      PRetCode = '*EOF   '

     C                   WHEN      *IN95 = *ON
     C                   EVAL      PRetCode = '*NRF   '

     C                   WHEN      *IN96 = *ON
     C                   EVAL      PRetCode = '*OPTION'

     C                   WHEN      *IN97 = *ON
     C                   EVAL      PRetCode = '*NOSEL '

     C                   WHEN      *IN98 = *ON
     C                   EVAL      PRetCode = '*CALL  '
     C                   ENDSL

     C                   IF        POption <> '*FREE  ' AND
     C                             POption <> '*VERIFY' AND
     C                             POption <> '*OPTION'
     C                   EVAL      DSSDY = SCHELP
     C                   EVAL      HelpTag = HPHTAG
     C                   ENDIF

     C                   EVAL      *INLR = *ON

     C                   RETURN
      *****************************************************************
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

     C     *Entry        PLIST

      ** Inputs

     C                   Parm                    PRetCode
     C                   Parm                    POption
     C                   Parm                    HelpRef
     C                   Parm                    HelpTag
     C                   Parm                    DSSDY

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2003
