     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Base Rate Cnv: File to Screen Format')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDBSRTCVT - SD Base Rate Conversion: File to Screen Format   *
      *                                                               *
      *  Function:  This module converts the fields of a Base Rate    *
      *             Code from their format as on file to a screen     *
      *             format                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD057871           Date 30Apr21               *
      *  Prev Amend No. CSD103             Date 10Aug20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240065             Date 09Jun06               *
      *                 BUG4660            Date 05Nov04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 08Jan01               *
      *                 CAP038  *CREATE    Date 24Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD057871 - Allow a blank Floor when calling ARR Calculator   *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  240065 - Allow negative base rates to be displayed.          *
      *           Use ZA0841 instead of ZEDIT.                        *
      *  BUG4660 - Current Base Rate must not be updated during amend.*
      *  CSD006 - Market Data Feed                                    *
      *  CAP038 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

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

      * Base Rate in File Format
     D BasRFilFmt    E DS                  EXTNAME(SDBSRTPD)

      * Base Rate in Screen Format
     D BasRScnFmt    E DS                  EXTNAME(SDBSRSPD)
     D   DDTSDT                       6    OVERLAY(DDDFTS:3)
     D   DDTSTM                       6    OVERLAY(DDDFTS:9)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)                                     240065
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                    240065
                                                                                              240065
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  240065
      ** External DS for Dealing Details                                                      240065
                                                                                              240065
     D ArrayNbrt       S              1A   DIM(12)                                            240065
      * Incoming Base Rate in screen format                                                   240065
                                                                                              240065
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD103
                                                                                              CSD103
      ** Parameters for ZA0920                                                                CSD103
     D @@RETC          S             10A                                                      CSD103
     D @@AMTW          S             13P 0                                                    CSD103
     D @@QECN          S              1P 0                                                    CSD103
     D @@AMTD          S             14A                                                      CSD103
                                                                                              CSD103
     D CSD103          S              1A                                                      CSD103
     D WWBadj          S             11P 7                                                    CSD103
     D WWFlor          S             11P 7                                                    CSD103
                                                                                              CSD103
      * LIBOR Fields                                                                          CSD103
     D LiborFlds       DS                                                                     CSD103
     D  DDBLRT                        1A                                                      CSD103
     D  DDRFRR                       10A                                                      CSD103
     D  DDCALM                        4A                                                      CSD103
     D  DDBADJ                       13A                                                      CSD103
     D  DDFLOR                       13A                                                      CSD103
     D  DDLBDY                        2A                                                      CSD103
     D  DDLODY                        2A                                                      CSD103
     D  DDOPSH                        1A                                                      CSD103
     D  DDRRDP                        2A                                                      CSD103
     D  DDDBAV                        1A                                                      CSD103
     D SCNSTR          C                   CONST('9999.9999999')                            MD057871
                                                                                              CSD103
     D PSARD           S              6                                                       CSD103
                                                                                              CSD103
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D DateIn          S              8S 0

      ** Parameter list for ZA0841                                                            240065
      ** Alpha field for numeric validation                                                   240065
     D @@ALPH          S             16A                                                      240065
      ** Millions/Thousands id (Y=function on)                                                240065
     D @@MTID          S              1A                                                      240065
      ** Amount calculation field                                                             240065
     D @@AMT           S             15  0                                                    240065
      ** Error code                                                                           240065
     D @@ERCD          S              1  0                                                    240065
      ** Number of decimal places                                                             240065
     D @@IDP           S              3  0                                                    240065
      ** Number of integers                                                                   240065
     D @@IINT          S              3  0                                                    240065
                                                                                              240065
     D WrkRate         S             11  7                                                    240065
     D IntNbrt         S              4A                                                      240065
                                                                                              240065
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   EXSR      INIT
      *
      ** SET OUTPUT SCREEN FIELDS
      *
     C                   EXSR      SETFLD
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - SET OUTPUT SCREEN FIELDS
      *****************************************************************
     C     SETFLD        BEGSR
      *
      * Base Rate Code
      *
     C                   MOVE      BACYCD        DDCYCD
     C                   MOVE      BABSRC        DDBSRC
      *
      * Base Rate Name
      *
     C                   MOVE      BABSRN        DDBSRN
      *
      * Base Rate Shortname
      *
     C                   MOVE      BABSRS        DDBSRS
      *
      * New Base Rate ( and current Base Rate)
      *
     C**********         MOVEL     *BLANK        ZFIELD                                       240065
     C**********         MOVE(P)   BANBRT        ZFIELD                                       240065

     C**********         CALLB     'ZEDIT'                                                    240065
     C**********         PARM                    ZFIELD           16                          240065
     C**********         PARM      7             ZADEC             1 0                        240065

     C**********         MOVE      ZFIELD        DDNBRT                                       240065
                                                                                             BUG4660
     C                   Z-ADD     7             @@IDP                                        240065
     C                   Z-ADD     4             @@IINT                                       240065
     C                   MOVE      *BLANKS       @@ALPH                                       240065
      *                                                                                       240065
      * Set-up decimal point and sign prior to using ZA0841 to format display.                240065
      *                                                                                       240065
     C                   MOVEA     *BLANKS       ArrayNbrt                                    240065
     C     BANBRT        IFLT      0                                                          240065
     C                   Z-SUB     BANBRT        WrkRate                                      240065
     C                   ELSE                                                                 240065
     C                   Z-ADD     BANBRT        WrkRate                                      240065
     C                   END                                                                  240065
     C                   MOVE      WrkRate       @@ALPH                                       240065
     C                   MOVEA     @@ALPH        ArrayNbrt                                    240065
     C                   MOVEA     BNDCSP        ArrayNbrt(9)                                 240065
     C                   MOVEL     WrkRate       IntNbrt                                      240065
     C                   MOVEA     IntNbrt       ArrayNbrt(5)                                 240065
     C                   MOVEA     '    '        ArrayNbrt(1)                                 240065
     C     BANBRT        IFLT      0                                                          240065
     C                   MOVEA     '-'           ArrayNbrt(4)                                 240065
     C                   END                                                                  240065
     C                   MOVEA     ArrayNbrt     @@ALPH                                       240065
                                                                                              240065
     C                   CALLB     'ZA0841'                                                   240065
                                                                                              240065
     C                   PARM      *BLANK        RetCodeOut                                   240065
     C                   PARM                    @@ALPH                         Display field 240065
     C                   PARM                    @@IDP                          no.of dec.plcs240065
     C                   PARM                    @@IINT                         no.of integers240065
     C                   PARM      'N'           @@MTID                         Mil/Thou      240065
     C                   PARM      *ZERO         @@ERCD                         Error code    240065
     C                   PARM      *ZERO         @@AMT                          File field    240065
     C                   PARM                    BNDCSP                                       240065
      *                                                                                       240065
      ** Return the formatted amount                                                          240065
     C                   MOVE      @@ALPH        DDNBRT                                       240065
                                                                                              240065
     C**********         MOVEL     *BLANK        ZFIELD                              BUG4660  240065
     C**********         MOVE(P)   BACBSR        ZFIELD                              BUG4660  240065
                                                                                             BUG4660
     C**********         CALLB     'ZEDIT'                                           BUG4660  240065
     C**********         PARM                    ZFIELD           16                 BUG4660  240065
     C**********         PARM      7             ZADEC             1 0               BUG4660  240065
                                                                                             BUG4660
     C**********         MOVE      ZFIELD        DDCBSR                                       240065

     C                   Z-ADD     7             @@IDP                                        240065
     C                   Z-ADD     4             @@IINT                                       240065
     C                   MOVE      *BLANKS       @@ALPH                                       240065
      *                                                                                       240065
      * Set-up decimal point and sign prior to using ZA0841 to format display.                240065
      *                                                                                       240065
     C                   MOVEA     *BLANKS       ArrayNbrt                                    240065
     C     BACBSR        IFLT      0                                                          240065
     C                   Z-SUB     BACBSR        WrkRate                                      240065
     C                   ELSE                                                                 240065
     C                   Z-ADD     BACBSR        WrkRate                                      240065
     C                   END                                                                  240065
     C                   MOVE      WrkRate       @@ALPH                                       240065
     C                   MOVEA     @@ALPH        ArrayNbrt                                    240065
     C                   MOVEA     BNDCSP        ArrayNbrt(9)                                 240065
     C                   MOVEL     WrkRate       IntNbrt                                      240065
     C                   MOVEA     IntNbrt       ArrayNbrt(5)                                 240065
     C                   MOVEA     '    '        ArrayNbrt(1)                                 240065
     C     BACBSR        IFLT      0                                                          240065
     C                   MOVEA     '-'           ArrayNbrt(4)                                 240065
     C                   END                                                                  240065
     C                   MOVEA     ArrayNbrt     @@ALPH                                       240065
                                                                                              240065
     C                   CALLB     'ZA0841'                                                   240065
                                                                                              240065
     C                   PARM      *BLANK        RetCodeOut                                   240065
     C                   PARM                    @@ALPH                         Display field 240065
     C                   PARM                    @@IDP                          no.of dec.plcs240065
     C                   PARM                    @@IINT                         no.of integers240065
     C                   PARM      'N'           @@MTID                         Mil/Thou      240065
     C                   PARM      *ZERO         @@ERCD                         Error code    240065
     C                   PARM      *ZERO         @@AMT                          File field    240065
     C                   PARM                    BNDCSP                                       240065
      *                                                                                       240065
      ** Return the formatted amount                                                          240065
     C                   MOVE      @@ALPH        DDCBSR                                       240065
                                                                                              240065
      * Value Date  New Base Rate
      *
     C                   MOVEL     *BLANKS       DDVDNR
     C     BAVDNR        IFNE      *ZERO
     C                   Z-ADD     BAVDNR        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     *BLANKS       DDVDNR
     C                   MOVEL     ZDATE         DDVDNR
     C                   ENDIF
                                                                                             BUG4660
      * Value Date  Current Base Rate                                                        BUG4660
                                                                                             BUG4660
     C                   MOVEL     *BLANKS       DDVDRC                                      BUG4660
     C                   IF        BAVDRC  <> 0                                              BUG4660
     C                   Z-ADD     BAVDRC        ZDAYNO                                      BUG4660
     C                   CALLB     'ZDATE2'                                                  BUG4660
     C                   PARM                    ZDAYNO                                      BUG4660
     C                   PARM                    BJDFIN                                      BUG4660
     C                   PARM                    ZDATE                                       BUG4660
     C                   PARM                    ZADATE                                      BUG4660
     C                   MOVEL     ZDATE         DDVDRC                                      BUG4660
     C                   ENDIF                                                               BUG4660
      *
      * ISDA Definition of Base Rate
      *
     C                   MOVE      BASCDD        DDSCDD
      *
      * Designated Maturity
      *
     C                   MOVE      BADGMA        DDDGMA
      *
      * Other Maturity Description
      *
     C                   MOVE      BAOMD1        DDOMD1
     C                   MOVE      BAOMD2        DDOMD2
      *                                                                                       CSD006
                                                                                              CSD006
      * Base Rate MDF identifier                                                              CSD006
     C                   Eval      DDFRNT = BAFRNT                                            CSD006
                                                                                              CSD006
      * Data source override                                                                  CSD006
     C                   Eval      DDBRDS = BABRDS                                            CSD006
                                                                                              CSD006
      * Data request id                                                                       CSD006
     C                   Eval      DDDTFR = BADTFR                                            CSD006
                                                                                              CSD006
      * Time stamp                                                                            CSD006
     C     BADFTS        IFEQ      *ZERO                                                      CSD006
     C                   EVAL      DDDFTS = *BLANK                                            CSD006
     C                   ELSE                                                                 CSD006
      ** Move last 6 digits HHMMSS                                                            CSD006
     C                   MOVE      BADFTS        DDTSTM
      ** Move first 8 digits CCYYMMDD
     C                   MOVEL     BADFTS        DateIn
     C                   EXSR      ZA0770                                                     CSD006
     C                   MOVE      DateOut       DDTSDT                                       CSD006
     C                   ENDIF                                                                CSD006
      *                                                                                       CSD006
     C                   IF        CSD103 = 'Y'                                               CSD103
      *                                                                                       CSD103
      * Backward-Looking Rate                                                                 CSD103
      *                                                                                       CSD103
     C                   MOVE      BABLRT        DDBLRT                                       CSD103
      *                                                                                       CSD103
      * Risk Free Rate                                                                        CSD103
      *                                                                                       CSD103
     C                   MOVE      BARFRR        DDRFRR                                       CSD103
      *                                                                                       CSD103
      * Calculation Method                                                                    CSD103
      *                                                                                       CSD103
     C                   MOVE      BACALM        DDCALM                                       CSD103
      *                                                                                       CSD103
      * Benchmark Adjustment                                                                  CSD103
      *                                                                                       CSD103
     C                   IF        BABADJ <> *ZEROS                                           CSD103
     C                   Z-ADD     BABADJ        WWBadj                                       CSD103
     C                   Z-ADD     *ZEROS        @@AMTW                                       CSD103
     C                   MOVE      WWBadj        @@AMTW                                       CSD103
     C                   EXSR      FMTRATE                                                    CSD103
     C                   MOVE      @@AMTD        DDBADJ                                       CSD103
     C                   ENDIF                                                                CSD103
      *                                                                                       CSD103
      * Floor                                                                                 CSD103
      *                                                                                       CSD103
     C**********         IF        BAFLOR <> *ZEROS                                  CSD103 MD057871
     C                   IF        BAFLOR <> 9999.999999                                    MD057871
     C                   Z-ADD     BAFLOR        WWFlor                                       CSD103
     C                   Z-ADD     *ZEROS        @@AMTW                                       CSD103
     C                   MOVE      WWFlor        @@AMTW                                       CSD103
     C                   EXSR      FMTRATE                                                    CSD103
     C                   MOVE      @@AMTD        DDFLOR                                       CSD103
     C                   ELSE                                                               MD058326
     C                   MOVEL     *BLANKS       DDFLOR                                     MD058326
     C                   ENDIF                                                                CSD103
      *                                                                                       CSD103
      * Lookback Days                                                                         CSD103
      *                                                                                       CSD103
     C                   MOVE      BALBDY        DDLBDY                                       CSD103
      *                                                                                       CSD103
      * Lockout Days                                                                          CSD103
      *                                                                                       CSD103
     C                   MOVE      BALODY        DDLODY                                       CSD103
      *                                                                                       CSD103
      * Observation Period Shift                                                              CSD103
      *                                                                                       CSD103
     C                   MOVE      BAOPSH        DDOPSH                                       CSD103
      *                                                                                       CSD103
      * Rate Rounding Decimal Places                                                          CSD103
      *                                                                                       CSD103
     C                   MOVE      BARRDP        DDRRDP                                       CSD103
      *                                                                                       CSD103
      * Day Basis for Average                                                                 CSD103
      *                                                                                       CSD103
     C                   MOVE      BADBAV        DDDBAV                                       CSD103
      *                                                                                       CSD103
     C                   ENDIF                                                                CSD103
      *                                                                                       CSD103
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZA0770 - Convert YYYYMMDD to date XXXXXX                      *                       CSD006
      *                                                               *                       CSD006
      *****************************************************************                       CSD006
     C     ZA0770        BEGSR                                                                CSD006
                                                                                              CSD006
     C                   CALLB     'ZA0770'                                                   CSD006
     C                   PARM                    RetCodeIn                                    CSD006
     C                   PARM                    DateIn                                       CSD006
     C                   PARM                    BJDFIN                                       CSD006
     C                   PARM                    DateOut           6 0                        CSD006
                                                                                              CSD006
     C                   ENDSR                                                                CSD006
      *****************************************************************                       CSD006
      /EJECT
      *****************************************************************
      * INIT - INITIALIZATION
      *****************************************************************
     C     INIT          BEGSR
      *
      ** BLANK OUTPUTS (EXCEPT FOR ACTION CODE WITHIN BASE RATE FORMAT)
      *
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     *BLANK        BasRScnFmt
     C                   MOVEL     *BLANKS       LiborFlds                                    CSD103
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
      *****************************************************************                       CSD103
      /EJECT                                                                                  CSD103
      *****************************************************************                       CSD103
      * FMTRATE - Format Rate for Display                             *                       CSD103
      *****************************************************************                       CSD103
     C     FMTRATE       BEGSR                                                                CSD103
                                                                                              CSD103
      ** Format using 7 decimal places                                                        CSD103
     C                   Z-ADD     7             @@QECN                                       CSD103
     C                   CALLB     'ZA0920'                                                   CSD103
     C                   PARM      *BLANK        @@RETC                                       CSD103
     C                   PARM                    @@AMTW                                       CSD103
     C                   PARM                    @@QECN                                       CSD103
     C                   PARM                    BNDCSP                                       CSD103
     C                   PARM      *BLANK        @@AMTD                                       CSD103
                                                                                              CSD103
     C                   ENDSR                                                                CSD103
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Base Rate in file format
     C                   PARM                    BasRFilFmt
      *
      * Output parameters
      *
      * Base Rate in screen format
     C                   PARM                    BasRScnFmt
      * LIBOR Screen Fields from File                                                         CSD103
     C                   PARM                    LiborFlds                                    CSD103
      *
      *
      ** Initialize program name
      *
     C                   MOVEL     'SDBSRTCVT'   DBPGM
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '100'         DBASE                          * DBERR 100 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Access Dealing Details                                                               240065
      *                                                                                       240065
     C                   CALL      'AODEALR1'                                                 240065
     C                   PARM      *BLANKS       @RTCD             7                          240065
     C                   PARM      '*FIRST '     @OPTN             7                          240065
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        240065
      *                                                                                       240065
      * Database Error                                                                        240065
      *                                                                                       240065
     C     @RTCD         IFNE      *BLANK                                                     240065
     C                   EVAL      BNDCSP =  '.'                                              240065
     C                   END                                                                  240065
                                                                                              CSD103
      ** Check if CLE172 is installed                                                         CSD103
                                                                                              CSD103
     C                   EVAL      CSD103 = 'N'                                               CSD103
     C                   CALLB     'AOSARDR0'                                                 CSD103
     C                   PARM      *BLANKS       @RTCD                                        CSD103
     C                   PARM      '*VERIFY'     @OPTN                                        CSD103
     C                   PARM      'CSD103'      PSARD                                        CSD103
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD103
                                                                                              CSD103
     C                   IF        @RTCD = *Blanks                                            CSD103
     C                   EVAL      CSD103 = 'Y'                                               CSD103
     C                   ENDIF                                                                CSD103
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
