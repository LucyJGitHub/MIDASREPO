     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CRS Country Details - Validation')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCRSN3VL - CRS Country Details Validation                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD050497           Date 11May18               *
      *  Prev Amend No. MD050479           Date 05May18               *
      *                 MD041294           Date 19Sep16               *
      *                 MD040876           Date 13Sep16               *
      *                 CGL177             Date 11Jan16               *
      *                 MD036274           Date 21Oct15               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050497 - User, Date and Time fields are not populated when *
      *             Reason was entered during Customer Insert         *
      *  MD050479 - Deleted country in the NAHO's CRS list of         *
      *             countries maintenance can't be re-added           *
      *  MD041294 - Customer extension details is missing in          *
      *             CUSD repair browse (Recompile)                    *
      *  MD040876 - CRS MQ (Recompile)                                *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  MD036274 - Local TIN validation changes                      *
      *  CGL157 - CRS Reporting                                       *
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
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE

      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D PCTIN           DS
     D  DPCTIN1                1      2
     D  DPCTIN2                3      4
     D  DPCTIN3                5      6
     D  DPCTIN4                7      8
     D  DPCTIN5                9     10
     D  DPCTIN6               11     12
     D  DPCTIN7               13     14
     D  DPCTIN8               15     16
     D  DPCTIN9               17     18
     D  DPCTIN0               19     20

     D PFDATE          DS
     D  DPEFF1                 1      6
     D  DPEFF2                 7     12
     D  DPEFF3                13     18
     D  DPEFF4                19     24
     D  DPEFF5                25     30
     D  DPEFF6                31     36
     D  DPEFF7                37     42
     D  DPEFF8                43     48
     D  DPEFF9                49     54
     D  DPEFF0                55     60

     D PXDATE          DS
     D  DPEXP1                 1      6
     D  DPEXP2                 7     12
     D  DPEXP3                13     18
     D  DPEXP4                19     24
     D  DPEXP5                25     30
     D  DPEXP6                31     36
     D  DPEXP7                37     42
     D  DPEXP8                43     48
     D  DPEXP9                49     54
     D  DPEXP0                55     60

      ** CRS Country Details OK indicators
     D OKCrsN        E DS                  Extname(SDECRSNPD)

      ** External DS for Bank Details
     D SDBANK        E DS                  Extname(SDBANKPD)

      ** External DS for SAR Details
     D SCSARD        E DS                  Extname(SCSARDPD)

      **  Short DS for access programs
     D DSFDY         E DS                  Extname(DSFDY)

      **  Long DS for access programs
     D DSSDY         E DS                  Extname(DSSDY)

     D ZMUSER          DS            17
     D  USRBCH                11     13

     D PCRSDT          DS
     D  DDCTRY                 1      2
     D  DDPREP                 3      3
     D  DDREPT                 4      4
     D  DDREPU                 5     14
     D  DDREPD                15     20
     D  DDREPM                21     26
     D  DDREP1                27     90
     D  DDREP2                91    154
     D  DDEVE1               155    156
     D  DDEVS1               157    159
     D  DDEVE2               160    161
     D  DDEVS2               162    164
     D  DDEVE3               165    166
     D  DDEVS3               167    169
     D  DDEVE4               170    171
     D  DDEVS4               172    174
     D  DDEVE5               175    176
     D  DDEVS5               177    179
     D  DDTINN               180    204
     D  DDEFFD               205    210
     D  DDEXPD               211    216
     D  DDCODO               217    217
     D  DDJACM               218    218
     D  DDMAIL               219    219
     D  DDPHON               220    220
     D  DDRPAY               221    221
     D  DDPEP1               222    285
     D  DDPEP2               286    349
     D  DDCRSA               350    350
     D  DDTINS               351    351                                                       CGL177

      ** Valid Non-A/C Holder Details layout
     D ValidCRSCtry  E DS                  Extname(SDVCRSNPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PEFFDT          S              5P 0 Dim(10)
     D PEXPDT          S              5P 0 Dim(10)
     D PCrsdS          S            351A   DIM(30)                                            CGL177
     D PCrsdF          S            222A   DIM(30)                                            CGL177

     D Retcd           S              7A
     D Option          S              7A
     D DDRTYP          S              1A

     D OKEFF2          S              1A
     D OKEFF3          S              1A
     D OKEFF4          S              1A
     D OKEFF5          S              1A
     D OKEFF6          S              1A
     D OKEFF7          S              1A
     D OKEFF8          S              1A
     D OKEFF9          S              1A
     D OKEFF0          S              1A
     D OKEXP2          S              1A
     D OKEXP3          S              1A
     D OKEXP4          S              1A
     D OKEXP5          S              1A
     D OKEXP6          S              1A
     D OKEXP7          S              1A
     D OKEXP8          S              1A
     D OKEXP9          S              1A
     D OKEXP0          S              1A

      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

     D I               S              3  0
     D RespMode        S              1
     D DDNAHO          S             10
     D WWCTRY          S              2
     D PCountry        S              2
     D X               S              2S 0
     D Y               S              2S 0
     D Z               S              2S 0
     D DDUSID          S             10
     D PINKJ           S              1
     D DeleteOK        S              1
     D PWarning        S              1
     D PCRSChk         S              1                                                     MD036274
     D DDCUST          S              6                                                     MD050497

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      ** Load Country Details

     C                   EVAL      X = 1
     C                   EVAL      Y = 1
     C                   DOW       X < 31
     C                   EVAL      PCRSDT = PCrsdS(X)
     C                   IF        DDCTRY = PCountry
     C                   EVAL      ValidCRSCtry = PCrsdF(X)
     C                   EVAL      X = X + 30
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   EVAL      DDUSID = PSUSER

      ** Validate Subject to reporting
      ** Validate Evidence Field
      ** Validate Effective date and expiry date

     C                   EXSR      SRVCrsr
     C                   EXSR      SrvTINN                                                  MD036274
     C                   EXSR      SRVEvdc
     C                   EXSR      SRVcEfEx

     C                   IF        Idx = 0
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      WWCTRY = PCrsdF(X)
     C                   IF        PCountry = WWCTRY
     C                   EVAL      PCrsdF(X) = ValidCRSCtry
     C                   EVAL      X = X + 30
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO
     C                   ENDIF

     C                   EVAL      DeleteOk = ' '
     C                   IF        (PINKJ = '1'
     C                             OR PWarning = 'Y')
     C                             AND Idx = 0
     C                   EXSR      SRVCDel
     C                   ENDIF

     C                   IF        DeleteOk = 'Y'
     C                   EVAL      X = 1
     C                   DOW       X < 31
     C                   EVAL      WWCTRY = PCrsdF(X)
     C                   IF        PCountry = WWCTRY
     C                   EVAL      %SUBST(PCrsdS(X):3:1) = '*'                                CGL177
     C                   EVAL      %SUBST(PCrsdF(X):3:6) = '*'                                CGL177
     C                   EVAL      %SUBST(PCrsdS(X):4:348) = *Blanks                        MD050479
     C                   EVAL      %SUBST(PCrsdF(X):9:213) = *Blanks                        MD050479
     C                   EVAL      %SUBST(PCrsdF(X):142:3) = x'00000f'                      MD050479
     C                   EVAL      %SUBST(PCrsdF(X):211:3) = x'00000f'                      MD050479
     C                   EVAL      %SUBST(PCrsdF(X):214:3) = x'00000f'                      MD050479
     C                   EVAL      Z = X
     C                   EVAL      X = X + 30
     C                   ENDIF
     C                   EVAL      X = X + 1
     C                   ENDDO

     C                   ENDIF

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVCDel - Validate Country on Delete
      *****************************************************************
     C     SRVCDel       BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

      ** Validate Country on Delete

     C                   CALLB     'SDVCDEL'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    DDCODO
     C                   PARM                    DDJACM
     C                   PARM                    DDMAIL
     C                   PARM                    DDPHON
     C                   PARM                    DDRPAY
     C                   PARM                    DDREPT
     C                   PARM                    DDTINN
     C                   PARM                    DDEFFD
     C                   PARM                    DDEXPD
     C                   PARM                    PWarning
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
     C                   PARM                    DDCTRYOK

     C                   PARM                    DeleteOk

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR
      *****************************************************************                     MD036274
      /EJECT                                                                                MD036274
      *****************************************************************                     MD036274
                                                                                            MD036274
      *****************************************************************                     MD036274
      ** SRVTINN - Validate TIN                                                             MD036274
      *****************************************************************                     MD036274
     C     SRVTINN       BEGSR                                                              MD036274
                                                                                            MD036274
      ** Reset variables updated by each module                                             MD036274
                                                                                            MD036274
     C                   EXSR      SRResetErrs                                              MD036274
                                                                                            MD036274
      ** Validate TIN                                                                       MD036274
                                                                                            MD036274
     C                   CALLB     'SDVTINN'                                                MD036274
      ** INPUTS                                                                             MD036274
      ** Return Code                                                                        MD036274
     C                   PARM                    RetCodeOut                                 MD036274
     C                   PARM      'Y'           PCRSChk                                    MD036274
      ** TIN                                                                                MD036274
     C                   PARM                    DDTINN                                     MD036274
     C                   PARM                    DDCTRY                                     MD036274
     C                   PARM                    DDREPT                                     MD036274
     C                   PARM                    DDCODO                                     MD036274
     C                   PARM                    DDJACM                                     MD036274
     C                   PARM                    DDMAIL                                     MD036274
     C                   PARM                    DDPHON                                     MD036274
     C                   PARM                    DDRPAY                                     MD036274
                                                                                            MD036274
      ** OUTPUTS                                                                            MD036274
      ** Error fields/message IDs/message data (arrays) from/to caller                      MD036274
     C                   PARM                    FldNamXAr                                  MD036274
     C                   PARM                    MsgIDXAr                                   MD036274
     C                   PARM                    MsgDtaXAr                                  MD036274
                                                                                            MD036274
     C                   PARM                    DDTINNOK                                   MD036274
     C                   PARM                    RVTINN                                     MD036274
     C                   PARM                    RVTINS                                       CGL177
                                                                                            MD036274
      ** Update error info with that returned from the validation module                    MD036274
                                                                                            MD036274
     C                   EXSR      SRUpdatErrs                                              MD036274
                                                                                            MD036274
     C                   ENDSR                                                              MD036274
                                                                                            MD036274
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRVCRSR - Validate Subject to Reporting
      *****************************************************************
     C     SRVCrsr       BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

      ** Validate Subject to Reporting

     C                   CALLB     'SDVCRSR'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Subject to Reporting and Reason
     C                   PARM      *BLANKS       DDCUST                                     MD050497
     C                   PARM                    DDCTRY                                     MD050497
     C                   PARM                    DDPEP1
     C                   PARM                    DDPEP2
     C                   PARM                    DDREPT
     C                   PARM                    DDREP1
     C                   PARM                    DDREP2
     C                   PARM                    BJRDNB
     C                   PARM                    DDUSID
     C                   PARM                    DDPREP                                       CGL177
      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Subject to Reporting - OK
     C                   PARM                    DDREPQOK
      ** Subject to Reporting Reason - OK
     C                   PARM                    DDREP1OK

     C                   PARM                    RVREPT
     C                   PARM                    RVREPR
     C                   PARM                    RVREPD
     C                   PARM                    RVREPM
     C                   PARM                    RVREPU


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVEvdc - Validate Evidence fields 1 to 5
      *****************************************************************
     C     SRVEvdc       BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

      ** Validate Country of TIN

     C                   CALLB     'SDVEVDC'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
     C                   PARM                    DDNAHO
     C                   PARM      'N'           DDRTYP
      ** Evidence 1
     C                   PARM                    DDEVE1
      ** Evidence Seq 1
     C                   PARM                    DDEVS1
      ** Evidence 2
     C                   PARM                    DDEVE2
      ** Evidence Seq 2
     C                   PARM                    DDEVS2
      ** Evidence 3
     C                   PARM                    DDEVE3
      ** Evidence Seq 3
     C                   PARM                    DDEVS3
      ** Evidence 4
     C                   PARM                    DDEVE4
      ** Evidence Seq 4
     C                   PARM                    DDEVS4
      ** Evidence 5
     C                   PARM                    DDEVE5
      ** Evidence Seq 5
     C                   PARM                    DDEVS5

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Evidence 1 - OK
     C                   PARM                    DDEVE1OK
      ** Evidence 2 - OK
     C                   PARM                    DDEVE2OK
      ** Evidence 3 - OK
     C                   PARM                    DDEVE3OK
      ** Evidence 4 - OK
     C                   PARM                    DDEVE4OK
      ** Evidence 5 - OK
     C                   PARM                    DDEVE5OK

     C                   PARM                    RVEVE1
     C                   PARM                    RVEVS1
     C                   PARM                    RVEVE2
     C                   PARM                    RVEVS2
     C                   PARM                    RVEVE3
     C                   PARM                    RVEVS3
     C                   PARM                    RVEVE4
     C                   PARM                    RVEVS4
     C                   PARM                    RVEVE5
     C                   PARM                    RVEVS5


      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRVcEfex - Validate Effective and Expiry Date
      *****************************************************************
     C     SRVcEfex      BEGSR

      ** Reset variables updated by each module

     C                   EXSR      SRResetErrs

     C                   EVAL      PCTIN = *Blanks
     C                   EVAL      PFDATE = *Blanks
     C                   EVAL      PXDATE = *Blanks
     C                   EVAL      DPCTIN1 = DDCTRY
     C                   EVAL      DPCTIN2 = *Blanks
     C                   EVAL      DPCTIN3 = *Blanks
     C                   EVAL      DPCTIN4 = *Blanks
     C                   EVAL      DPCTIN5 = *Blanks
     C                   EVAL      DPCTIN6 = *Blanks
     C                   EVAL      DPCTIN7 = *Blanks
     C                   EVAL      DPCTIN8 = *Blanks
     C                   EVAL      DPCTIN9 = *Blanks
     C                   EVAL      DPCTIN0 = *Blanks
     C                   EVAL      DPEFF1 = DDEFFD
     C                   EVAL      DPEFF2 = *Blanks
     C                   EVAL      DPEFF3 = *Blanks
     C                   EVAL      DPEFF4 = *Blanks
     C                   EVAL      DPEFF5 = *Blanks
     C                   EVAL      DPEFF6 = *Blanks
     C                   EVAL      DPEFF7 = *Blanks
     C                   EVAL      DPEFF8 = *Blanks
     C                   EVAL      DPEFF9 = *Blanks
     C                   EVAL      DPEFF0 = *Blanks
     C                   EVAL      DPEXP1 = DDEXPD
     C                   EVAL      DPEXP2 = *Blanks
     C                   EVAL      DPEXP3 = *Blanks
     C                   EVAL      DPEXP4 = *Blanks
     C                   EVAL      DPEXP5 = *Blanks
     C                   EVAL      DPEXP6 = *Blanks
     C                   EVAL      DPEXP7 = *Blanks
     C                   EVAL      DPEXP8 = *Blanks
     C                   EVAL      DPEXP9 = *Blanks
     C                   EVAL      DPEXP0 = *Blanks

      ** Validate Effective and Expiry Date

     C                   CALLB     'SDVEFEX'
      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Country of TIN
     C                   PARM                    PCTIN
      ** Effective Date
     C                   PARM                    PFDATE
      ** Expiry Date
     C                   PARM                    PXDATE

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Effective Date 1 - OK
     C                   PARM                    DDEFF1OK
      ** Effective Date 2 - OK
     C                   PARM                    OKEFF2
      ** Effective Date 3 - OK
     C                   PARM                    OKEFF3
      ** Effective Date 4 - OK
     C                   PARM                    OKEFF4
      ** Effective Date 5 - OK
     C                   PARM                    OKEFF5
      ** Effective Date 6 - OK
     C                   PARM                    OKEFF6
      ** Effective Date 7 - OK
     C                   PARM                    OKEFF7
      ** Effective Date 8 - OK
     C                   PARM                    OKEFF8
      ** Effective Date 9 - OK
     C                   PARM                    OKEFF9
      ** Effective Date 10 - OK
     C                   PARM                    OKEFF0
      ** Expiry Date 1 - OK
     C                   PARM                    DDEXP1OK
      ** Expiry Date 2 - OK
     C                   PARM                    OKEXP2
      ** Expiry Date 3 - OK
     C                   PARM                    OKEXP3
      ** Expiry Date 4 - OK
     C                   PARM                    OKEXP4
      ** Expiry Date 5 - OK
     C                   PARM                    OKEXP5
      ** Expiry Date 6 - OK
     C                   PARM                    OKEXP6
      ** Expiry Date 7 - OK
     C                   PARM                    OKEXP7
      ** Expiry Date 8 - OK
     C                   PARM                    OKEXP8
      ** Expiry Date 9 - OK
     C                   PARM                    OKEXP9
      ** Expiry Date 10 - OK
     C                   PARM                    OKEXP0
      ** Effective date 1-10
     C                   PARM                    PEFFDT
      ** Expiry date 1-10
     C                   PARM                    PEXPDT

     C                   IF        DDEFF1OK = 'Y'
     C                   EVAL      RVEFFD = PEFFDT(1)
     C                   ENDIF
     C                   IF        DDEXP1OK = 'Y'
     C                   EVAL      RVEXPD = PEXPDT(1)
     C                   ENDIF

      ** Update error info with that returned from the validation module

     C                   EXSR      SRUpdatErrs

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      *****************************************************************
      ** SRResetErrs - Reset error information that is received back  *
      **    from each validation module.                              *
      *****************************************************************
     C     SRResetErrs   BEGSR

     C                   EVAL      RetCodeOut = *Blanks

      ** Reset error & warning fields/message IDs/message data (arrays)

     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRUpdatErrs - Update error information with that received back*
      **    from each validation module.                               *
      *****************************************************************
     C     SRUpdatErrs   BEGSR

      ** Update error fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF

      ** Set Error Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx

      ** Update warning fields/message IDs/message data (arrays)

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      *On
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF

      ** Set Warning Index

     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** INPUTS
      ** Response mode
      ** CRS Country Details

     C                   PARM                    RespMode
     C                   PARM                    DDNAHO
     C                   PARM                    PCountry
     C                   PARM                    PCrsdS
     C                   PARM                    PINKJ
     C                   PARM                    PWarning

      ** OUTPUTS
      ** CRS Country Details OK inds
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Warning fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
      ** Valid CRS Country details layout (DS) from/to caller

     C                   PARM                    OKCrsN
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
     C                   PARM                    PCrsdF

      ** Access Bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       Retcd
     C                   PARM      '*FIRST '     Option
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error

     C     Retcd         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    Dbfile
     C                   MOVEL     '001'         Dbase
     C                   MOVEL     @OPTN         Dbkey
     C                   EXSR      SRERR
     C                   ENDIF


      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
      /COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRERR - Exception Errors                                     *
      *****************************************************************
     C     SRERR         BEGSR

     C                   MOVEL     'SDCRSN3VL'   Dbpgm
     C                   MOVE      *On           *INU7
     C                   MOVE      *On           *INU8
     C                   MOVE      *On           *INLR

     C                   DUMP

      **  Terminate the program

     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE

      ********************************************************************
**  CPY@
(c) Finastra International Limited 2015
