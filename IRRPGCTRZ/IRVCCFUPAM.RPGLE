     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR: Validate Up-front fee amount (Caps/Clrs)')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Up-Front Fee (Premium)                           *
      *                                                               *
      *  IRVCCFUPAM                                                   *
      *                                                               *
      *  Function:  This module validates the up-front amount and     *
      *             returns a blank return indicator if no error is   *
      *             found; otherwise the return indicator contains    *
      *             'Error'.                                          *
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
      *  Prev Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 01Feb98               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
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
 
      ** External data structure for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
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
 
      ** switchable feature field passed as parameter.
     D CIR001          S              1A
 
      ** upfront value date.
     D SUPVD           S              6A
 
      ** upfront fee amount.
     D SUPFE           S             14A
 
      ** Currency entered checked against currency code.
     D SUCUCY          S              3A
 
      ** Decimal data length passed as a parameter to ZALIGN
     D ZADEC           S              1  0
 
      ** Digital data length passed as a parameter to ZALIGN
     D ZADIG           S              2  0
 
      ** Field Passed to ZALIGN on which the work is done
     D ZFIELD          S             16A
 
      ** Indicator to show whether or not ZALIGN was successful
     D ZALIGNok        S              1A
 
      ** Error message passed back to calling program from module
     D Msgid1          S                   LIKE(#Msgid)
 
      ** Up-Front Fee indicator - *IN02 (may be Rollup ind)
     D SUPFEok         S              1A
 
      * Deal CCY code valid indicator - *IN23
     D SUCUCYok        S              1A
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
 
      *****************************************************************
      *
      ** Only perform Up-front Fee validation if enhancement
      ** CIR001 is ON.
      *
     C     CIR001        IFEQ      'Y'
      *
     C                   MOVE      'N'           ErrorFound
     C                   MOVE      '0'           SUPFEok
      *
      ** If Deal Ccy code is valid
      *
     C     SUCUCYok      IFEQ      'Y'
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SUCUCY        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      *                                                                   CIR001
      ** Validate Up-front Fee Amount.                                    CIR001
      *                                                                   CIR001
     C     SUPFE         IFEQ      *BLANKS                                                     CIR00
     C     SUPVD         IFNE      *BLANKS                                                     CIR00
      * Avoid exceeding size of error code array.                         CIR001
     C                   MOVE      'MMA0072'     Msgid1                                        CIR00
     C                   MOVE      'Y'           ErrorFound                                    CIR00
     C                   END                                                                   CIR00
     C                   END                                                                   CIR00
      *                                                                   CIR001
     C     SUPFEok       IFEQ      'Y'                                                         CIR00
     C     SUPFE         ANDNE     *BLANKS                                                     CIR00
      *                                                                   CIR001
      ** Validate the Amount using ZALIGN.                                CIR001
      *                                                                   CIR001
     C                   Z-ADD     0             UPFEX            13 0                         CIR00
     C                   MOVE      *BLANKS       ZFIELD                                        CIR00
     C                   MOVEL     SUPFE         ZFIELD                                        CIR00
     C                   Z-ADD     A6NBDP        ZADEC                                         CIR00
     C     13            SUB       A6NBDP        ZADIG                                         CIR00
     C                   CALLB     'ZALIGN'                                                    S0115
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *                                                                   S01157
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        UPFEX                                         CIR00
     C                   END                                                                   CIR00
      *                                                                   CIR001
      ** UPFEX is numeric work field for comparison with 0.               CIR001
      *                                                                   CIR001
     C     ZALIGNok      IFEQ      'N'                                                         CIR00
     C     UPFEX         ORLE      0                                                           CIR00
      * Avoid exceeding size of error code array.                         CIR001
     C                   MOVE      'MMA0073'     Msgid1                                        CIR00
     C                   MOVE      'Y'           ErrorFound                                    CIR00
     C                   MOVE      'Y'           ZALIGNok                                      CIR00
     C                   END                                                                   CIR00
     C                   END                                                                   CIR00
     C                   END                                                                   CIR00
     C                   END                                                                   CIR00
      *                                                                   CIR001
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
     C                   PARM                    CIR001
     C                   PARM                    SUPFEok
     C                   PARM                    SUCUCYok
     C                   PARM                    SUCUCY
     C                   PARM                    SUPFE
     C                   PARM                    SUPVD
 
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
