     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Interest Payment frequency')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVINTPYFQ - Validate Interest Payment Frequency             *
      *                                                               *
      *  Function:  This module accepts a field containing the        *
      *             Interest payment frequency and confirms whether   *
      *             it is valid. If it is not the 10A return code will*
      *             contain 'Error'. If it is valid the return field  *
      *             will be blank                                     *
      *                                                               *
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
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CIR007 - Overnight Index Swaps                               *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Interest payment frequency passed as a parameter from calling program
     D   STIPFR        S              1A
 
      ** Interest payment date passed as a parameter from calling program m
     D   STNIPD        S              6A
 
      ** Interest rate calendar feature passed as a parameter from calling program
     D  CIR001         S              1A
 
      ** Interest payment frequency                                         rogram
     D  STIPFRok       S              1A
 
      ** Interest rate change day in month                                  rogram
     D  STICFDok       S              1A
 
      ** Average rate method indicator passed as a parameter from calling program. Default 'N'
     D  SAVRAM         S              1A
 
     D  SRICFR         S              1A
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message passed back to calling program
     D  Msgid1         S                   LIKE(#Msgid)
 
      ** Error message passed back to calling program
     D  Msgid2         S                   LIKE(#Msgid)
 
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
                                                                                              CIR007
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
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      ** Validate Our Interest Payment Frequency.
 
     C     STIPFR        IFNE      *BLANK
     C     STNIPD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0041'     Msgid1
     C
     C                   ELSE
 
     C     STIPFR        IFNE      'M'
     C     STIPFR        ANDNE     'Q'
     C     STIPFR        ANDNE     'X'
     C     STIPFR        ANDNE     'Y'
 
      **  If switchable feature is ON, 'Z' or 'C' must be a valid
      **    interest payment frequency
 
     C     CIR001        IFEQ      'Y'
     C     STIPFR        ANDNE     'C'
     C     STIPFR        ANDNE     'Z'
     C     CIR001        ORNE      'Y'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0042'     Msgid1
     C                   END
                                                                                              CAP055
      ** Interest payment frequency 'C' and 'Z' are not valid for deal type                   CAP055
      ** 'RR', 'RP' and 'RF'                                                                  CAP055
                                                                                              CAP055
     C                   IF        (PDealTyp = 'RR' OR PDealTyp = 'RP' OR                     CAP055
     C                             PDealTyp = 'RF') AND                                       CAP055
     C                             (STIPFR = 'C' OR STIPFR = 'Z')                             CAP055
     C                   EVAL      ErrorFound = 'Y'                                           CAP055
     C                   EVAL      Msgid1 = 'MMA0042'                                         CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CIR007
      ** If CIR007 is on, Deal Type is 'RS' and Rate Change Frequency                         CIR007
      ** Code is 'O', then the Interest Payment Frequency Code must                           CIR007
      ** not be set to 'C'.                                                                   CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND SRICFR = 'O'  AND STIPFR = 'C'                         CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   MOVE      'N'           STIPFRok                                     CIR007
     C                   MOVE      'MMA1176'     Msgid1                                       CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
     C                   END
     C                   END
 
      ********
      **
      * The section of code below is relevant to interest rate caps, collars and
      * and floors only. The code can be omitted by passing a blank field in SAVRAM.
      **
      ********
 
     C     STIPFRok      IFEQ      'Y'
     C     STIPFR        ANDNE     *BLANKS
     C     SAVRAM        ANDEQ     'Y'
     C     STICFDok      ANDEQ     'Y'
 
     C     SRICFR        IFEQ      *BLANKS
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA0056'     Msgid2
     C                   MOVE      'N'           STIPFRok
     C                   MOVE      'Y'           ErrorFound
     C                   ELSE
 
     C     SRICFR        IFEQ      'Q'
     C     STIPFR        ANDNE     'Q'
     C     STIPFR        ANDNE     'X'
     C     STIPFR        ANDNE     'Y'
     C     SRICFR        OREQ      'X'
     C     STIPFR        ANDNE     'X'
     C     STIPFR        ANDNE     'Y'
     C     SRICFR        OREQ      'Y'
     C     STIPFR        ANDNE     'Y'
 
      * Avoid exceeding size of error code array.
 
     C                   MOVE      'MMA0057'     Msgid2
     C                   MOVE      'Y'           ErrorFound
     C                   END
     C                   MOVE      'N'           STIPFRok
     C                   END
     C                   END
     C                   END
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
     C                   PARM                    STIPFR
     C                   PARM                    STNIPD
     C                   PARM                    CIR001
      * relevant to interest rate collars, caps and floors only.
     C                   PARM                    STIPFRok
     C                   PARM                    STICFDok
     C                   PARM                    SAVRAM
     C                   PARM                    SRICFR
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
     C
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
