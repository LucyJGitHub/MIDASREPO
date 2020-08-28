     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate our/their base rate code')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Validation Module                            *
      *                                                               *
      *  IRVBRATCDE - Validate Our/Their Base Rate Code               *
      *                                                               *
      *  Function:  This module receives a parameter cotaining the    *
      *             Our/Their Base Rate Code field and confirms       *
      *             whether it has a valid value.                     *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP055             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007             Date 11May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 08Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CIR007 - Overnight Index Swaps                               *
      *  CSD006 - Use long DS with SDBSRTPD.                          *
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
 
      **Base Rate Code details accessed via access programme
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)
 
      **Dummy field passed used to pass SDBSRT as a parameter
     D***DSFDY*********DS           200                                         CSD006
     D   DSSDY         DS           800                                         CSD006
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      **
      **Field Containing SUBRTT or STBRTT - our/their base rate code
     D   SUBRTT        S              2A
 
      **Currency Indicator passed as a parameter from calling program
     D   SUCUCYok      S              1A
 
      **Currency code passed as a parameter from calling program
     D   SUCUCY        S              3A
 
      **Switchable feature field passed as a parameter from calling program
     D   CIR001        S              1A
 
      **Payment frequencies passed as a parameter from calling frequencies
     D   STIPFR        S              1A
 
      **Error Message passed back to calling programme
     D   Msgid1        S                   LIKE(#Msgid)
 
      **Error message passed back to calling programme
     D   Msgid2        S                   LIKE(#Msgid)
 
      ** Rate Change Frequency Code                                                           CIR007
     DPRAtChgFq        S              1A                                                      CIR007
                                                                                              CIR007
      ** Deal Type used as Parameter                                                          CIR007
     DPDealTyp         S              2A                                                      CIR007
                                                                                              CIR007
      ** OVERNIGHT INDEX SWAPS                                                                CIR007
     DCIR007           S              1A                                                      CIR007
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
                                                                                              CIR007
      ** If CIR007 is on , Deal Type is 'RS' and Rate Change Frequency                        CIR007
      ** Code is 'O' , Base Rate Code must be entered.                                        CIR007
                                                                                              CIR007
     C                   IF        CIR007 = 'Y' AND PDealTyp = 'RS'                           CIR007
     C                             AND PRatChgFq = 'O'                                        CIR007
     C                             AND SUBRTT = *BLANKS                                       CIR007
     C                   MOVE      'Y'           ErrorFound                                   CIR007
     C                   MOVE      'MMA1182'     Msgid1                                       CIR007
     C                   ENDIF                                                                CIR007
                                                                                              CIR007
      ** Base Rate Code is mandatory for Deal type 'RR', 'RP' and RF'                         CAP055
                                                                                              CAP055
     C                   IF        PDealTyp = 'RR' AND SUBRTT = *BLANKS OR                    CAP055
     C                             PDealTyp = 'RP' AND SUBRTT = *BLANKS OR                    CAP055
     C                             PDealTyp = 'RF' AND SUBRTT = *BLANKS                       CAP055
     C                   EVAL      ErrorFound = 'Y'                                           CAP055
     C                   EVAL      Msgid1 = 'MMA1301'                                         CAP055
     C                   ENDIF                                                                CAP055
                                                                                              CAP055
     C     SUBRTT        IFNE      *BLANKS
     C     SUCUCYok      ANDEQ     'Y'
     C                   CALLB     'AOBSRTR0'
      **
      **Call Access program to validate our base rate code
      **
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      SUCUCY        @UCUCY            3
     C                   PARM      SUBRTT        @UBRTT            2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                          CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                          CSD006
 
      **
      **If Base Rate code not valid display error message
      **
     C     @RTCD         IFNE      *BLANK
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0014'     Msgid1
     C                   ELSE
     C                   MOVEL     BABSRC        SUBRTT
     C                   ENDIF
     C                   ENDIF
      **
      **Our Base Rate Code must be blank if int payment frequency is 'C'
      **
     C     CIR001        IFEQ      'Y'
     C     SUBRTT        ANDNE     *BLANKS
     C     STIPFR        ANDEQ     'C'
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMA0019'     Msgid2
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
     C                   PARM                    SUBRTT
     C                   PARM                    SuCucyOK
     C                   PARM                    SUCUCY
     C                   PARM                    CIR001
     C                   PARM                    STIPFR
     C                   PARM                    PRatChgFq                                    CIR007
     C                   PARM                    PDealTyp                                     CIR007
     C                   PARM                    CIR007                                       CIR007
 
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
