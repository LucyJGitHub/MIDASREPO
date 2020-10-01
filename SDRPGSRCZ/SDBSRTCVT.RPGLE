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
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
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
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)                                       CSD103
     F                                     RENAME(@BAREDG:SDBSRTXX)                           CSD103

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
     D ArrayBadj       S              1A   DIM(14)                                            CSD103
                                                                                              CSD103
      ** BSRT Backward-Looking Rate Fields                                                    CSD103
     D BasRBckfld      DS            27                                                       CSD103
     D  DDBLRT                 1      1                                                       CSD103
     D  DDLBDY                 2      3                                                       CSD103
     D  DDLODY                 4      5                                                       CSD103
     D  DDPDLY                 6      7                                                       CSD103
     D  DDBADJ                 8     21                                                       CSD103
     D  DDAVOP                22     22                                                       CSD103
     D  DDBRAC                23     24                                                       CSD103
     D  DDWGHT                25     25                                                       CSD103
     D  DDLBAC                26     27                                                       CSD103
                                                                                              CSD103
     D SDBSRTDS      E DS                  EXTNAME(SDBSRTL0:*INPUT)                           CSD103
     D                                     PREFIX(W)                                          CSD103
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
     D IntBadj         S              5A                                                      CSD103
     D DecBadj         S              8A                                                      CSD103
                                                                                              CSD103
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
      *                                                                                       CSD103
      * Backward-Looking Rate                                                                 CSD103
      *                                                                                       CSD103
     C                   MOVE      BABLRT        DDBLRT                                       CSD103
      *                                                                                       CSD103
      * Default Lookback Days for Settlement Base Rate                                        CSD103
      *                                                                                       CSD103
     C                   MOVE      BALBDY        DDLBDY                                       CSD103
      *                                                                                       CSD103
      * Default Lockout Days                                                                  CSD103
      *                                                                                       CSD103
     C                   MOVE      BALODY        DDLODY                                       CSD103
      *                                                                                       CSD103
      * Default Payment Delay Days                                                            CSD103
      *                                                                                       CSD103
     C                   MOVE      BAPDLY        DDPDLY                                       CSD103
      *                                                                                       CSD103
      * Benchmark Adjustment                                                                  CSD103
      *                                                                                       CSD103
     C                   MOVEL     BABADJ        IntBadj                                      CSD103
     C                   MOVE      BABADJ        DecBadj                                      CSD103
     C                   MOVEA     IntBadj       ArrayBadj(1)                                 CSD103
     C                   MOVEA     BNDCSP        ArrayBadj(6)                                 CSD103
     C                   MOVEA     DecBadj       ArrayBadj(7)                                 CSD103
     C                                                                                        CSD103
     C                   MOVE      *BLANKS       @@ALPH                                       CSD103
     C                   MOVEA     ArrayBadj     @@ALPH                                       CSD103
     C                   CALLB     'ZA0840'                                                   CSD103
     C                   PARM      *BLANK        RetCodeOut                                   CSD103
     C                   PARM                    @@ALPH                         Display field CSD103
     C                   PARM      8             @@IDP                          no.of dec.plcsCSD103
     C                   PARM      5             @@IINT                         no.of integersCSD103
     C                   PARM      'N'           @@MTID                         Mil/Thou      CSD103
     C                   PARM      *ZERO         @@ERCD                         Error code    CSD103
     C                   PARM      *ZERO         @@AMT                          File field    CSD103
     C                   PARM                    BNDCSP                                       CSD103
      *                                                                                       CSD103
     C                   MOVE      @@ALPH        DDBADJ                                       CSD103
      *                                                                                       CSD103
      * Averaging Option                                                                      CSD103
      *                                                                                       CSD103
     C                   MOVE      BAAVOP        DDAVOP                                       CSD103
      *                                                                                       CSD103
      * Base Rate for Accrual                                                                 CSD103
      *                                                                                       CSD103
     C                   MOVE      BABRAC        DDBRAC                                       CSD103
      *                                                                                       CSD103
      * Weight Convention                                                                     CSD103
      *                                                                                       CSD103
     C                   MOVE      BAWGHT        DDWGHT                                       CSD103
      *                                                                                       CSD103
      * Default Lookback Days for Accrual                                                     CSD103
      *                                                                                       CSD103
     C     SDBRAC        CHAIN     SDBSRTXX      SDBSRTDS             99                      CSD103
     C     *IN99         IFNE      '1'                                                        CSD103
     C                   MOVE      WBALBDY       DDLBAC                                       CSD103
     C                   ELSE                                                                 CSD103
     C                   MOVE      *ZEROS        DDLBAC                                       CSD103
     C                   ENDIF                                                                CSD103
      *                                                                                       CSD006
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
     C                   MOVEL     ##ACTN        DDACTN
      *
     C                   ENDSR
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
      * Backward-Looking Rate Fields                                                          CSD103
     C                   PARM                    BasRBckfld                                   CSD103
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
      *                                                                                       CSD103
     C     SDBRAC        KLIST                                                                CSD103
     C                   KFLD                    BACYCD                                       CSD103
     C                   KFLD                    BABRAC                                       CSD103
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
