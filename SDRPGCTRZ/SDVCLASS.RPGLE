     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Classification Code')                *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCLASS - Validate FATCA Classification Code/Date           *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL154             Date 13Oct14               *
      *                 MD027561           Date 03Jul14               *
      *                 MD026523           Date 02May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL154 - FATCA Reporting (Recompile)                         *
      *  MD027561 - FATCA Classification Date is not updated to date  *
      *             when FATCA Classification was changed             *
      *  MD026523 - Some FATCA fields in FATCA Non-account Holder     *
      *             Details Maintenance Screen are not updated        *
      *             automatically                                     *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
 
      ** Midas FATCA Classification Code
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
 
      ** Short Data Structure for Access Objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for NewTrntVal string
     D NewTrnTVal      DS           200
     D  DataToVal              1      5
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
     D SysVal1         C                   'FATCADftCLsTakeon'
     D SysVal2         C                   'FATCADftCLsNewCustNH'
     D SysVal3         C                   'FATCAEffectStartDate'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D RTNCDE          S              7
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIx             S              3P 0
     D @PFTC           S              5
 
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
      ** Parameter variables for AOSVALR0 string
     D PRtcd           S              7
     D SValK1          S             20
     D SVal1           S            200
     D SValK2          S             20
     D SVal2           S            200
     D SValK3          S             20
     D SVal3           S            200
     D SValK4          S             20
     D SVal4           S            200
     D SValK5          S             20
     D SVal5           S            200
     D SValK6          S             20
     D SVal6           S            200
     D SValK7          S             20
     D SVal7           S            200
     D SValK8          S             20
     D SVal8           S            200
     D SValK9          S             20
     D SVal9           S            200
     D SValK0          S             20
     D SVal10          S            200
     D DDCLDS          S             50
     D DDPFCE          S             50
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      DFCLAC = *BLANKS
     C                   EVAL      DDUSIA = *BLANKS
     C                   EVAL      DDUSIA = *BLANKS
     C                   EVAL      DFCLDS = *BLANKS
     C                   EVAL      DFPFCE = *BLANKS
     C                   EVAL      DFPCLA = *BLANKS
     C                   EVAL      DFCLAF = *BLANKS
     C                   EVAL      DFCLAD = *ZERO
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      'Y'           DDCLACOK
     C                   MOVE      'Y'           DDCLADOK
 
     C                   IF        DDCLAC = *BLANKS
 
     C                   IF        SVal3  <> *BLANKS
     C                   MOVE      SVal3         WUWSDT
 
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
     C                   ENDIF
 
     C                   IF        WUWFDT >= BJRDNB
     C                   EVAL      DDCLAC = SVal1
     C                   ELSE
     C                   EVAL      DDCLAC = SVal2
     C                   ENDIF
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'FCCLAF    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0445'
 
     C                   ENDIF
 
      ** Check if the classification code entered by the user is
      ** defined on the FATCA classification code
 
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDCLAC        @PFTC
     C     SDFATC        PARM      SDFATC        DSFDY
 
      ** If value entered by user is not found on the FATCA
      ** classification code file then return an error
 
     C                   IF        @RTCD = '*NRF'
     C                   MOVE      'N'           DDCLACOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLAC'      FldNamXAr(Idx)
     C                   MOVEL     'USS0173'     MsgIdXAr(Idx)
     C                   EVAL      DDCLDS = *BLANKS                                         MD027561
     C                   ELSE
     C                   EVAL      DDCLAC = @PFTC
     C                   EVAL      DFCLAC = DDCLAC
     C                   EVAL      DDUSIA = FCUSIA
     C                   EVAL      DFCLDS = FCDESC
     C                   IF        DDCLAC <> DDCLACO AND
     C                             DDCLACO <> *BLANKS
     C                   EVAL      DFPCLA = DDCLACO
     C                   ELSE
     C                   EVAL      DFPCLA = DDPCLA
     C                   ENDIF
     C**********         EVAL      DDCLACO = DDCLAC                                         MD026523
     C                   EVAL      DFPFCE = DDPFCE
     C                   EVAL      DDCLDS = FCDESC
     C                   ENDIF
 
     C                   IF        DDCLAF <> *BLANK
                                                                                            MD027561
      ** Defualt Classification Date when Classification Code has Changed                   MD027561
     C                   IF        DFCLAC <> DDCLACO                                        MD027561
     C                             AND DDCLACO <> *BLANKS                                   MD027561
     C                             AND DDCLAFO = DDCLAF                                     MD027561
     C                             AND WCLAFlag <> 'Y'                                      MD027561
     C                   CALLB     'ZDATE2'                                                 MD027561
     C                   PARM      BJRDNB        ZDAYNO            5 0                      MD027561
     C                   PARM                    BJDFIN                                     MD027561
     C                   PARM                    ZDATE             6 0                      MD027561
     C                   PARM                    DATEB             7                        MD027561
                                                                                            MD027561
     C                   MOVE      ZDATE         DDCLAF                                     MD027561
     C                   MOVE      ZDATE         DFCLAF                                     MD027561
     C                   MOVE      BJRDNB        DFCLAD            5 0                      MD027561
                                                                                            MD027561
     C                   IF        DDCLAF <> DDCLAFO                                        MD027561
     C                   EVAL      WIx = WIx + 1                                            MD027561
     C                   EVAL      WFldNmXAr(WIx) = 'FCCLAF    '                            MD027561
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0384'                              MD027561
     C                   EVAL      WCLAFlag = 'Y'                                           MD027561
     C                   ENDIF                                                              MD027561
     C                   ENDIF                                                              MD027561
                                                                                            MD027561
     C                   TESTN                   DDCLAF               98
     C     *IN98         IFEQ      *OFF
     C                   EVAL      DDCLADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCLAF    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0133'
     C                   ELSE
     C                   MOVE      DDCLAF        WUWSDT
 
      ** Check Screen Date - Run date
 
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      BJDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
 
      ** Send message '*Error occured on CALL...'
 
     C                   EVAL      DDCLADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCLAF    '
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZDATE1'
     C                   ENDIF
 
      ** Return code is an Error
 
     C                   IF        W0RTN = '*ERROR*'
 
      ** Send message 'FATCA Classification Date'
 
     C                   EVAL      DDCLADOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCLAF    '
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0133'
     C                   ELSE
     C                   MOVE      WUWFDT        DFCLAD
     C                   EVAL      DFCLAF = DDCLAF
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        DFCLAC <> *BLANKS
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
 
     C                   MOVE      ZDATE         DDCLAF
     C                   MOVE      ZDATE         DFCLAF
     C                   MOVE      BJRDNB        DFCLAD            5 0
 
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'FCCLAF    '
     C                   EVAL      WMsgIdXAr(WIx)  = 'USS0384'
     C                   EVAL      WCLAFlag = 'Y'                                           MD027561
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** RETURN
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    RTNCDE
 
      ** FATCA Classification Code (Original)
     C                   PARM                    DDCLACO           5
 
      ** FATCA Classification Code
     C                   PARM                    DDCLAC            5
     C                   PARM                    DDPCLA            5
 
      ** FATCA Classification Date (Original)
     C                   PARM                    DDCLAFO           6
 
      ** FATCA Classification Date
     C                   PARM                    DDCLAF            6
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJRDNB            5 0
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** FATCA Classification Date - OK
     C                   PARM                    DDCLADOK          1
 
      ** Classification Code - OK
     C                   PARM                    DDCLACOK          1
 
     C                   PARM                    DDUSIA            1
     C                   PARM                    DFCLAC            5
     C                   PARM                    DFCLAD            5 0
     C                   PARM                    DFPCLA            5
     C                   PARM                    DFCLAF            6
     C                   PARM                    DFCLDS           50
     C                   PARM                    DFPFCE           50
     C                   PARM                    WCLAFlag          1                        MD027561
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM      SysVal2       SValK2
     C                   PARM                    SVal2
     C                   PARM      SysVal3       SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10
 
     C                   IF        PRtcd <> *Blanks  AND
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SValK1
     C                   EVAL      DBASE = 901
     C                   EVAL      DBPGM = 'SDVCLASS'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2013
