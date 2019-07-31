     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Reset Network Activity Control File')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001435 - Midas GL Reset Network Activity Control File.     *
      *                                                               *
      *  Function:  This module set the network activity according    *
      *             the network definition.                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD045731           Date 27Sep17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CGL013  *CREATE    Date 31Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045731 - Checking of holiday is done by comparing the      *
      *             current date to the system rundate.               *      
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************
 
     F**********GLNWKAPD  UF A E           K DISK                   INFSR(*PSSR)            MD045731
     FGLNWKAL0  UF A E           K DISK                   INFSR(*PSSR)                      MD045731
      ** Midas GL Network Activity Control File
 
      *****************************************************************
      *                                                               *
      * Use of Indicators                                             *
      *                                                               *
      * Database Access Indicators                                    *
      *                                                               *
      *                                                               *
      * Database Error Indicators                                     *
      *                                                               *
      * U7 - Abnormal Completion                                      *
      * U8 - File Out of Balance                                      *
      * U7 + U8 - Database Error                                      *
      *                                                               *
      * Other Indicators                                              *
      *                                                               *
      * 99 - Multi-purpose                                            *
      *                                                               *
      *****************************************************************
 
      ** Automatically included D-specs
      ** ==============================
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Manually included D-specs
      ** =========================
 
      ** Named constants
      ** ---------------
 
      ** Arrays and Data Structures
      ** --------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data Structure for Bank Details.
 
     D SDNWRK        E DS                  EXTNAME(SDNWRKPD)
      **  Data Structure for Network Details.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  First DS for access programs, long data structure.
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Second DS for access programs, short data structure.
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
      **  Third DS for access programs, very long data structure.
 
      * 'Now' date                                                                          MD045731
     D                 DS                                                                   MD045731
     D CurDATE                 1      6  0                                                  MD045731
     D CurDD                   1      2  0                                                  MD045731
     D CurMM                   3      4  0                                                  MD045731
     D CurYY                   5      6  0                                                  MD045731
     D CurDDA                  1      2                                                     MD045731
     D CurMMA                  3      4                                                     MD045731
     D CurYYA                  5      6                                                     MD045731
      * 'Now' time                                                                          MD045731
     D                 DS                                                                   MD045731
     D CurTIME                 1      6  0                                                  MD045731
     D CurHH                   1      2  0                                                  MD045731
     D CurMI                   3      4  0                                                  MD045731
     D CurSS                   5      6  0                                                  MD045731
     D CurHHA                  1      2                                                     MD045731
     D CurMIA                  3      4                                                     MD045731
     D CurSSA                  5      6                                                     MD045731
                                                                                            MD045731
      ** Declared variables
      ** ------------------
 
     D P@RTCD          S              7A                                        Return Code
     D P@OPTN          S              7A                                        Option
     D P@NWRK          S              6A                                        Network
 
      ** Input Specs
      ** -----------
 
      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
 
      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*
 
      ** Init processing uses the standard *INZSR subroutine
 
     C                   EVAL      P@OPTN = '*FIRST'                            Option
 
     C                   DOU       P@RTCD <> *BLANKS
 
      **  Access Networks.
 
     C                   CALLB     'AONWRKR1'
     C                   PARM      *BLANKS       P@RTCD                         Return Code
     C                   PARM                    P@OPTN                         Option
     C                   PARM      *BLANKS       P@NWRK                         Network
     C     SDNWRK        PARM      SDNWRK        DSLDY
 
     C                   IF        P@RTCD = *BLANKS
 
      **  Access Network Activity Control File.
 
     C*****EDNWRK        CHAIN     GLNWKAPD                           99                    MD045731
     C     EDNWRK        CHAIN     GLNWKAL0                           99                    MD045731
 
     C                   EXSR      GET_CurDT                                                MD045731
     C                   MOVE      CurDATE       ZDATEI                                     MD045731
     C                   EXSR      ZDATE1                                                   MD045731
      ** If prevent automatic submission at start of business.
 
     C                   IF        EDPASS = 'Y'
     C                   EVAL      MTSSTS = 'I'                                 Inactive
     C                   ELSE
     C                   EVAL      MTSSTS = 'A'                                 Active
     C                   ENDIF
 
      ** If prevent automatic submission if non-working day.
 
     C                   IF        EDPASN = 'Y'
     C**********                   AND BJDNWD > BJRDNB + 1                                  MD045731
     C                             AND BJRDNB <> ZDAYNO                                     MD045731
     C                   EVAL      MTSSTS = 'I'                                 Inactive
     C                   ENDIF
 
      ** If the network is in delete mode.
 
     C                   IF        EDTYLC = 'D'
     C                   EVAL      MTSSTS = 'I'                                 Inactive
     C                   ENDIF
 
      **  Update Network Activity Control File.
 
     C   99              EVAL      MTNWRK = EDNWRK
     C   99              WRITE     GLNWKAD0
     C  N99              UPDATE    GLNWKAD0
 
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      *INLR = *On
     C                   RETURN
 
      ********************************************************************                  MD045731
      /SPACE 5                                                                              MD045731
      ********************************************************************                  MD045731
      * Get Current Date and Time                                                           MD045731
      ********************************************************************                  MD045731
     C     GET_CurDT     BEGSR                                                              MD045731
     C                   TIME                    TimeDate         12 0                      MD045731
     C                   MOVE      TimeDate      DMY               6                        MD045731
      *                                                                                     MD045731
     C     PDTFMT        IFEQ      'DMY'                                                    MD045731
     C                   EVAL      CurDDA = %SUBST(DMY:1:2)                                 MD045731
     C                   EVAL      CurMMA = %SUBST(DMY:3:2)                                 MD045731
     C                   EVAL      CurYYA = %SUBST(DMY:5:2)                                 MD045731
     C                   END                                                                MD045731
      *                                                                                     MD045731
     C     PDTFMT        IFEQ      'MDY'                                                    MD045731
     C                   EVAL      CurDDA = %SUBST(DMY:3:2)                                 MD045731
     C                   EVAL      CurMMA = %SUBST(DMY:1:2)                                 MD045731
     C                   EVAL      CurYYA = %SUBST(DMY:5:2)                                 MD045731
     C                   END                                                                MD045731
      *                                                                                     MD045731
     C     PDTFMT        IFEQ      'YMD'                                                    MD045731
     C                   EVAL      CurDDA = %SUBST(DMY:5:2)                                 MD045731
     C                   EVAL      CurMMA = %SUBST(DMY:3:2)                                 MD045731
     C                   EVAL      CurYYA = %SUBST(DMY:1:2)                                 MD045731
     C                   END                                                                MD045731
     C                   MOVEL     TimeDate      CurTIME                                    MD045731
     C                   ENDSR                                                              MD045731
      ********************************************************************                  MD045731
      ********************************************************************                  MD045731
      /SPACE 5                                                                              MD045731
      ********************************************************************                  MD045731
      * Convert a date to day number                                                        MD045731
      ********************************************************************                  MD045731
     C     ZDATE1        BEGSR                                                              MD045731
     C                   CALLB     'ZDATE1'                                                 MD045731
     C                   PARM                    ZDATEI            6                        MD045731
     C                   PARM      *ZEROS        ZDAYNO            5 0                      MD045731
     C                   PARM      BJDFIN        ZDFIN             1                        MD045731
     C                   PARM                    ErrorFlag         1                        MD045731
     C                   ENDSR                                                              MD045731
      ********************************************************************                  MD045731
      /SPACE 5                                                                              MD045731
      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *------------------------------------------------------------------------*
 
     C     *INZSR        BEGSR
      *    ------        -----
      *                                                                                     MD045731
     C     *ENTRY        PLIST                                                              MD045731
     C                   PARM                    PDTFMT            3                        MD045731
      *
      ** Initialise Copyright Array
     C                   MOVEA     CPY@          CPY@@            80
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   MOVEL     PSProcPgm     DBpgm
     C                   OUT       LDA
 
      ** Retrieve Bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     P@RTCD                         Return Code
     C                   PARM      '*FIRST '     P@OPTN                         Option
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *    ------        -----
     C     @INZSR        ENDSR
 
      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
 
     C     *PSSR         BEGSR
      *    ----------    ------
 
     C                   DUMP
     C                   ROLBK
 
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
 
     C                   RETURN
 
      *    ----------    ------
     C     @PSSR         ENDSR
 
      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
