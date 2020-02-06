     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Amounts')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVPDAM - Validate Amounts                                   *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1095654          Date 13Mar13               *
      *                 AR1078092          Date 20Jan13               *
      *                 263415             Date 01Aug12               *
      *                 263360             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1095654 - Loan Principal amount cannot be entered as       *
      *              PDCL for Principal already exists                *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  263415 - Impossible to manually create PDCL for Interest only*
      *         - Only default amounts if they are blank, not 0. Only *
      *           allow input of I or P amounts for Loan PDCL if no   *
      *           PDCL of that type already exists for this Loan.     *
      *  263360 - PDCL for Interest created with wrong amount         *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *
     FLELOAML0  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Past Due & Original Loan Link File Format                                            263415
     FLEPDUEL2  IF   E           K DISK    INFSR(*PSSR)                                       263415
     F                                     PREFIX(X_)                                         263415
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others)
      ** the LDA layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields
      ** in the  Program Status Data Structures.
      ** They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant
      ** giving the size of the arrays.
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
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
 
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
      *
      ** Index for arrays of error message ids etc
      *
     D Idx             S              3P 0
      *
     D zadig           S              2P 0
      *
     D C_AUTO          S              1
     D E_FEAUTO        S              1
     D E_FEAMTP        S             13  0
     D BNDCSP          S              1
      *
     D NPDPR           S             15  0
     D NPDIN           S             15  0
     D NPDFA           S             15  0
      *
     D DDPDPROK        S              1
     D DDPDINOK        S              1
     D DDPDFAOK        S              1
     D DDSEINOK        S              1                                                       263415
     D COBMode         S              1                                                    AR1078092
      *
     D RecordType      S              1
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
      ** Additional Field Definitions
      *
     D OLPRIN          S              1
     D OLINT           S              1
     D WORLN           S              6
     D WPDPR           S             13  0
     D @@RETC          S             10
     D @@AMTW          S             15  0
     D W@DECP          S              1  0
     D @@DCSP          S              1
     D @@AMTP          S             16
     D @@AMTD          S             17
     D @@MTID          S              1
     D WPDIN           S             13  0
     D PRtcd           S              7
     D POptn           S              7
     D PKey            S              3
     D WVDAT           S              5  0
     D WLASN           S              3  0
     D @@ALPH          S             16
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@ERCD          S              1  0
     D @@AMT           S             15  0
 
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
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             NPDPR
     C                   Z-ADD     0             NPDIN
     C                   Z-ADD     0             NPDFA
      *
     C                   MOVE      *BLANK        OLPRIN                                       263415
     C                   MOVE      *BLANK        OLINT                                        263415
     C                   MOVE      DDORLN        WORLN
      *
      ** VALIDATION
      *
      ** Loan Principal Amount
      *
      ** Loan amounts cannot be used for a Fee
      *
     C                   IF        RecordType <> Loan
     C**********                   AND (DDPDPR <> *BLANKS                                     263415
     C**********                   OR DDPDIN <> *BLANKS )                                     263415
      *
     C                   IF        DDPDPR <> *BLANKS
     C                   EVAL      DDPDPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045630'
     C                   ENDIF
      *
     C                   IF        DDPDIN <> *BLANKS
     C                   EVAL      DDPDINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045631'
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Check that no PDCL for Principal exists for this Loan                                263415
      *                                                                                       263415
     C                   Z-ADD     A6NBDP        @@IDP                                        263415
     C     13            SUB       A6NBDP        @@IINT                                       263415
     C                   MOVE      *BLANKS       @@ALPH                                       263415
     C                   MOVE      DDPDPR        @@ALPH                                       263415
     C                   MOVE      'N'           @@MTID                                       263415
      *                                                                                       263415
     C                   EXSR      ZA0840                                                     263415
     C                   Z-ADD     @@AMT         NPDPR                                        263415
      *                                                                                       263415
     C     WKEY2         SETLL     LEPDUEL2                                                   263415
     C     WKEY2         READE     LEPDUEL2                               99                  263415
     C     *IN99         IFEQ      *OFF                                                       263415
      *                                                                                       263415
     C     X_YPDCT       IFEQ      'P'                                                        263415
     C                   IF        NPDPR <> 0                                                 263415
     C                             AND COBMode <> 'Y'                                      AR1095654
     C                   MOVE      'N'           DDPDPROK                                     263415
     C                   ADD       1             Idx                                          263415
     C                   EVAL      FldNamXAr(Idx) = 'DDPDPR'                                  263415
     C                   MOVEL     '5045788'     MsgIdXAr(Idx)                                263415
     C                   ELSE                                                                 263415
     C                   MOVE      'Y'           OLPRIN                                       263415
     C                   ENDIF                                                                263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
     C     X_YPDCT       IFEQ      'I'                                                        263415
     C     DDSEIN        ANDEQ     'N'                                                        263415
     C                   MOVE      'N'           DDSEINOK                                     263415
     C                   ADD       1             Idx                                          263415
     C                   EVAL      FldNamXAr(Idx) = 'DDSEIN'                                  263415
     C                   MOVEL     '5045787'     MsgIdXAr(Idx)                                263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
      ** Default it to sum(PRAM)
      *
     C                   IF        DDPDPR = *BLANKS
     C**********                   AND C_AUTO = 'N'                                           263360
     C                             AND DDPDPROK = 'Y'                                         263415
     C                             AND OLPRIN <> 'Y'                                          263415
      *
     C                   Z-ADD     0             WPDPR
     C     WKEY1         SETLL     LELOAML0
     C     WKEY2         READE     LELOAML0                             9999
     C                   DOW       *IN99 = *OFF
     C                             AND AMTP = 'PD'
     C                   ADD       PRAM          WPDPR
     C     WKEY2         READE     LELOAML0                             9999
     C                   ENDDO
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      WPDPR         @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C                   MOVE      @@AMTP        DDPDPR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDPDPR        @@ALPH
     C                   MOVE      'N'           @@MTID
      *
     C                   EXSR      ZA0840
      *
      ** Non numeric or incorrect decimals
      *
     C                   IF        @@ERCD = 1
     C                             OR @@ERCD = 2
     C                   EVAL      DDPDPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045610'
     C                   ENDIF
      *
      ** If amount is OK
      *
     C                   IF        DDPDPROK = 'Y'
     C                   IF        DDPDPR = *BLANKS
     C                             OR @@AMT = 0
     C**********         MOVE      *BLANKS       DDPDPR                                       263415
     C                   Z-ADD     0             NPDPR
     C                   ELSE
     C                   MOVE      @@ALPH        DDPDPR
     C                   Z-ADD     @@AMT         NPDPR
     C                   ENDIF
     C                   ENDIF
      *
      ** Loan Interest Amount
      *
      ** Check that no PDCL for Interest exists for this Loan                                 263415
      *                                                                                       263415
     C                   MOVE      *BLANKS       @@ALPH                                       263415
     C                   MOVE      DDPDIN        @@ALPH                                       263415
      *                                                                                       263415
     C                   EXSR      ZA0840                                                     263415
     C                   Z-ADD     @@AMT         NPDIN                                        263415
      *                                                                                       263415
     C     WKEY2         SETLL     LEPDUEL2                                                   263415
     C     WKEY2         READE     LEPDUEL2                               99                  263415
     C     *IN99         IFEQ      *OFF                                                       263415
      *                                                                                       263415
     C     X_YPDCT       IFEQ      'I'                                                        263415
     C                   IF        NPDIN <> 0                                                 263415
     C                             AND COBMode <> 'Y'                                      AR1078092
     C                   MOVE      'N'           DDPDINOK                                     263415
     C                   ADD       1             Idx                                          263415
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIN'                                  263415
     C                   MOVEL     '5045673'     MsgIdXAr(Idx)                                263415
     C                   ELSE                                                                 263415
     C                   MOVE      'Y'           OLINT                                        263415
     C                   ENDIF                                                                263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
     C     X_YPDCT       IFEQ      'P'                                                        263415
     C     DDSEIN        ANDEQ     'N'                                                        263415
     C                   MOVE      'N'           DDSEINOK                                     263415
     C                   ADD       1             Idx                                          263415
     C                   EVAL      FldNamXAr(Idx) = 'DDSEIN'                                  263415
     C                   MOVEL     '5045672'     MsgIdXAr(Idx)                                263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
     C                   ENDIF                                                                263415
      *                                                                                       263415
      ** Default it to sum(INTA)
      *
     C                   IF        DDPDIN = *BLANKS
     C**********                   AND C_AUTO = 'N'                                           263360
     C**********                   AND (DDCAPI <>'N'                                          263360
     C**********                   OR C_AUTO <> 'N')                                          263360
     C                             AND DDPDINOK = 'Y'                                         263415
     C                             AND OLINT <> 'Y'                                           263415
     C                             AND (DDCAPI <> 'N' OR DDSEIN <> 'N')                       263360
     C                   Z-ADD     0             WPDIN
     C     WKEY1         SETLL     LELOAML0
     C     WKEY2         READE     LELOAML0                             9999
     C                   DOW       *IN99 = *OFF
     C                             AND AMTP = 'PD'
     C                   ADD       INTA          WPDIN
     C     WKEY2         READE     LELOAML0                             9999
     C                   ENDDO
      *
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      WPDIN         @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C                   MOVE      @@AMTP        DDPDIN
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDPDIN        @@ALPH
     C                   MOVE      'N'           @@MTID
      *
     C                   EXSR      ZA0840
      *
      ** Non numeric or incorrect decimals
      *
     C                   IF        @@ERCD = 1
     C                             OR @@ERCD = 2
     C                   EVAL      DDPDINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIN'
     C                   EVAL      MsgIdXAr(Idx)  = '5045791'
     C                   ENDIF
      *
      ** If amount is OK
      *
     C                   IF        DDPDINOK = 'Y'
     C                   IF        DDPDIN = *BLANKS
     C                             OR @@AMT = 0
     C**********         MOVE      *BLANKS       DDPDIN                                       263415
     C                   Z-ADD     0             NPDIN
     C                   ELSE
     C                   MOVE      @@ALPH        DDPDIN
     C                   Z-ADD     @@AMT         NPDIN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Fee Amount
      *
      ** Fee amounts cannot be used for a Loan
      *
     C                   IF        RecordType = Loan
     C                             AND DDPDFA <> *BLANKS
      *
     C                   EVAL      DDPDFAOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDFA'
     C                   EVAL      MsgIdXAr(Idx) = '5045629'
      *
     C                   ELSE
      *
      ** Default it to Fee Past Due Amount
      *
     C                   IF        DDPDFA = *BLANKS
     C                   CALLB     'ZA0921'
     C                   PARM      *BLANK        @@RETC
     C                   PARM      E_FEAMTP      @@AMTW
     C                   PARM      A6NBDP        W@DECP
     C                   PARM      BNDCSP        @@DCSP
     C                   PARM      *BLANK        @@AMTP
     C                   PARM      *BLANK        @@AMTD
     C                   MOVE      @@AMTP        DDPDFA
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     13            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      DDPDFA        @@ALPH
     C                   MOVE      'N'           @@MTID
      *
     C                   EXSR      ZA0840
      *
      ** Non numeric or incorrect decimals
      *
     C                   IF        @@ERCD = 1
     C                             OR @@ERCD = 2
     C                   EVAL      DDPDFAOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDFA'
     C                   EVAL      MsgIdXAr(Idx) = '5045792'
     C                   ENDIF
      *
      ** If amount is OK
      *
     C                   IF        DDPDFAOK = 'Y'
     C                   IF        DDPDFA = *BLANKS
     C                             OR @@AMT = 0
     C                   MOVE      *BLANKS       DDPDFA
     C                   Z-ADD     0             NPDFA
     C                   ELSE
     C                   MOVE      @@ALPH        DDPDFA
     C                   Z-ADD     @@AMT         NPDFA
     C                   ENDIF
     C                   ENDIF
      *
      ** If amounts are blank
      *
     C     DDPDFAOK      IFEQ      'Y'
     C     DDPDFA        ANDEQ     *BLANKS
     C     DDFECU        ANDNE     *BLANKS
     C                   EVAL      DDPDFAOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDFA'
     C                   EVAL      MsgIdXAr(Idx) = '5045632'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EMAIN         TAG
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUTS
      *
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Other parms
      *
     C                   PARM                    TrnDets
     C                   PARM                    C_AUTO
     C                   PARM                    E_FEAUTO
     C                   PARM                    E_FEAMTP
     C                   PARM                    BNDCSP
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    NPDPR
     C                   PARM                    NPDIN
     C                   PARM                    NPDFA
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK values
      *
     C                   PARM                    DDPDPROK
     C                   PARM                    DDPDINOK
     C                   PARM                    DDPDFAOK
     C                   PARM                    DDSEINOK                                     263415
     C                   PARM                    COBMode                                   AR1078092
      *
      ** Currency formatting info
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      DDCCY         PKey
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     WKEY2         KLIST
     C                   KFLD                    WORLN
      *
     C     WKEY1         KLIST
     C                   KFLD                    WORLN
     C                   KFLD                    WVDAT
     C                   KFLD                    WLASN
      *
     C                   MOVE      *LOVAL        WVDAT
     C                   MOVE      *LOVAL        WLASN
      *
      ** Program, module and procedure names for DB Error processing
      ** ===========================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ZA0840 - VALIDATE/REFORMAT AMOUNT                             *
      *****************************************************************
     C     ZA0840        BEGSR
      *
     C                   CALLB     'ZA0840'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM      *ZERO         @@AMT
     C                   PARM                    BNDCSP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
