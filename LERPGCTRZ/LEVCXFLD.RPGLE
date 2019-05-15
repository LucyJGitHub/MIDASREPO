     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE PDCL Conversion - Cross check fields')        *
      *****************************************************************
      *                                                               *
      *  Midas - Lending Module                                       *
      *                                                               *
      *  LEVCXFLD - Validate Cross checks                             *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. CLE071             Date 18Jul18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD020128           Date 19Apr13               *
      *                 AR1078092          Date 20Jan13               *
      *                 263415             Date 01Aug12               *
      *                 263360             Date 01Aug12               *
      *                 263228             Date 01Aug12               *
      *                 262728             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  MD020128 - LEC000456 runs very slow                          *
      *  AR1078092 - Event Code of 45021706 (settlement account is    *
      *              (blocked) is not user configurable               *
      *  263415 - Impossible to manually create PDCL for Interest     *
      *           only                                                *
      *         - Allow for PDCL for Interest only + correct various  *
      *           other validation errors.                            *
      *  263360 - PDCL for Interest created with wrong amount         *
      *  263228 - No accrued interest postings for PDCL               *
      *  262728 - Validation error for Decreased Principal Indicator  *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************

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
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(LEPDCLPD)
      *
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(LEEPDCLPD)
      *
      ** Valid Transaction Details layout
     D ValidPDCL     E DS                  EXTNAME(LEVPDCLPD)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      *
      ** Formatting Details
     D DSSDY         E DS                  EXTNAME(DSSDY   )
      *
      ** Customer lending ICD
      *
     D #A              S              9  0 INZ
     D DSBCN           S              3  0 INZ DIM(9) ASCEND
     D DSBCE           S              3  0 INZ DIM(9)
     D DSRCN           S              3  0 INZ DIM(9) ASCEND
     D DSRCE           S              3  0 INZ DIM(9)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
     D BJRDNB          S              5  0
     D BJDFIN          S              1
     D NBCDY           S              3  0
     D NBCSD           S              5  0
     D NRCDY           S              3  0
     D NRCSD           S              5  0
      *
      ** Establish the transaction type
     D RecordType      S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
      *
      ** Additional Field Definitions
     D ZDate           S              6  0
     D Filler          S              7
     D WDAYS           S              5  0
     D WIDX            S              1  0
     D WDAYS1          S              5  0
     D WDAYS2          S              5  0
     D Ix              S              2  0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
      *
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
      *
      ** CROSS VALIDATION OF DIFFERENT FIELDS ON SCREEN
      *
      ** Capitalised Indicator (N) and Separate Indicator (N),
      ** no interest amount
      *
     C                   IF        DDCAPI = 'N'
     C                             AND DDSEIN = 'N'
     C                             AND DDPDIN <> *BLANKS
     C                             AND DDCAPIOK = 'Y'                                         263415
     C                             AND COBMode <> 'Y'
     C
     C                   EVAL      DDPDINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045601'
     C                   ENDIF
      *
      ** Capitalised Indicator (Y) and Separate Indicator (Y)
      ** not allowed
      *
     C                   IF        DDCAPI = 'Y'
     C                             AND DDSEIN = 'Y'
     C                             AND DDCAPIOK = 'Y'                                         263415
     C                   EVAL      DDCAPIOK = 'N'
     C                   EVAL      DDSEINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDCAPI'
     C                   EVAL      MsgIdXAr(Idx) = '5045602'
     C                   EVAL      Idx        += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDSEIN'
     C                   EVAL      MsgIdXAr(Idx)  = '5045603'
     C                   ENDIF
      *
      ** Decrease Indicator (N) and loan, Take on account
      ** must be present
      *
     C                   IF        DDDEPI = 'N'
     C                             AND DDDEPIOK = 'Y'                                         263415
     C                             AND DDTLPR = *BLANKS
     C                             AND NPDPR > 0                                              263415
     C                             AND COBMode <> 'Y'
     C                   EVAL      DDTLPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045604'
     C                   ENDIF
      *
      ** Loan Principal: Valid only if Decrease is 'N'
      *
     C                   IF        DDDEPI = 'Y'
     C                             AND DDDEPIOK = 'Y'                                         263415
     C                             AND DDTLPR <> *BLANKS
     C                   EVAL      DDTLPROK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLPR'
     C                   EVAL      MsgIdXAr(Idx) = '5045611'
     C                   ENDIF
      *
      **Loan*Principal:*Valid*only*if*the*PDCL*principal*amount********                       263415
      ***is*entered****************************************************                       263415
     C**********         IF        DDTLPR =  *BLANKS                                          263415
     C**********                   AND RecordType = Loan                                      263415
     C**********                   AND DDPDPR <> *BLANKS                                      263415
     C**********                   AND DDPDPROK = 'Y'                                         263415
     C**********                   AND DDDEPI = 'N'                                           263415
     C**********         EVAL      DDTLPROK    = 'N'                                          263415
     C**********         EVAL      Idx        += 1                                            263415
     C**********         EVAL      FldNamXAr(Idx) = 'DDTLPR'                                  263415
     C**********         EVAL      MsgIdXAr(Idx) = '5045612'                                  263415
     C**********         ENDIF                                                                263415
      *
      ** Loan Interest: Valid only if Decrease is 'N'
      *
     C                   IF        DDDEPI = 'Y'
     C                             AND DDDEPIOK = 'Y'                                         263415
     C                             AND DDTLIN <> *BLANKS
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045617'
     C                   ENDIF
      *
      ** Loan Interest: if loan, required if Decrease Indicator is
      ** 'N' and Separate Ind is 'Y'
      *
     C                   IF        RecordType <> Loan
      *
     C                   IF        DDTLIN <> *BLANKS
     C                             AND DDTLINOK = 'Y'
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045616'
     C                   ENDIF
      *
      ** Fee Take on : if Decrease Indicator is not 'Y', the take
      ** on account is required
      *
     C                   IF        DDTLFE = *BLANKS
     C                             AND COBMode <> 'Y'
     C**********                   AND DDDEPI <> 'Y'                                          263415
     C                   EVAL      DDTLFEOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLFE'
     C                   EVAL      MsgIdXAr(Idx) = '5045651'
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        DDTLIN = *BLANKS
     C                             AND DDDEPI = 'N'
     C                             AND DDSEIN = 'Y'
     C                             AND NPDIN > 0                                              263415
     C                             AND COBMode <> 'Y'
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045618'
     C                   ENDIF
      *
     C                   IF        DDTLIN <> *BLANKS
     C                             AND DDDEPI <> 'N'
     C                             AND DDSEIN <> 'Y'
     C                             AND DDTLINOK = 'Y'
     C                   EVAL      DDTLINOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDTLIN'
     C                   EVAL      MsgIdXAr(Idx) = '5045634'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** AMOUNTS: Principal and Interest cannot be blank for a Loan
      *
     C     DDPDINOK      IFEQ      'Y'
     C     DDPDPROK      ANDEQ     'Y'
     C*****DDPDIN        ANDEQ     *BLANKS                                             263228 263415
     C     NPDIN         ANDEQ     0                                                          263415
     C*****DDPDPR        ANDEQ     *BLANKS                                                    263415
     C     NPDPR         ANDEQ     0                                                          263415
     C     RecordType    ANDEQ     Loan
     C**********         eval      DDPDPROK    = 'N'                                          263415
     C                   EVAL      DDORLNOK = 'N'                                             263415
     C                   EVAL      Idx += 1
     C**********         eval      FldNamXAr(Idx) = 'DDPDPR'                                  263415
     C                   EVAL      FldNamXAr(Idx) = 'DDORLN'                                  263415
     C                   EVAL      MsgIdXAr(Idx) = '5045645'
     C**********         ENDIF                                                         263228 263415
     C*****DDPDPROK      IFEQ      'Y'                                                 263228 263415
     C*****DDPDINOK      ANDEQ     'Y'                                                 263228 263415
     C*****DDPDIN        ANDEQ     *BLANKS                                             263228 263415
     C*****DDPDPR        ANDEQ     *BLANKS                                             263228 263360
     C*****RecordType    ANDEQ     Loan                                                263228 263415
      ***Only*if*Capitalised*Indicator*and*Separate*Indicator*are*not*N                       263415
     C**********         IF        DDCAPI = 'N'                                               263360
     C**********                   and DDSEIN = 'Y'                                           263360
     C**********         IF        DDCAPI = 'Y'                                        263360 263415
     C**********                   or DDSEIN = 'Y'                                     263360 263415
     C**********         eval      DDPDINOK    = 'N'                                          263415
     C**********         eval      Idx        += 1                                            263415
     C**********         eval      FldNamXAr(Idx) = 'DDPDIN'                                  263415
     C**********         eval      MsgIdXAr(Idx)  = '5045633'                                 263415
     C**********         ENDIF                                                                263415
     C                   ENDIF
      *
      ** AMOUNTS: Fee Principal cannot be blank for a Fee
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
      ** AMOUNTS: PDCL Principal must be <= than the Outstanding                              262728
      ** Principal if Decreased Principal Indicator is Y                                      262728
      *
     C     DDPDPROK      IFEQ      'Y'                                                        262728
     C     DDDEPI        ANDEQ     'Y'                                                        262728
     C     NPDPR         ANDNE     *ZEROS                                                     262728
     C     NPDPR         IFGT      NLOAM                                                      262728
     C                   EVAL      DDPDPROK = 'N'                                             262728
     C                   EVAL      Idx += 1                                                   262728
     C                   EVAL      FldNamXAr(Idx) = 'DDPDPR'                                  262728
     C                   EVAL      MsgIdXAr(Idx) = '5045662'                                  262728
     C                   ENDIF                                                                262728
     C                   ENDIF                                                                262728
      *                                                                                       262728
      ** AMOUNTS: PDCL Interest can be entered only if Outstanding                            263228
      ** interest is > 0                                                                      263228
      *                                                                                       263228
     C     DDPDINOK      IFEQ      'Y'                                                        263228
     C*****DDDEPI        ANDEQ     'Y'                                                 263228 263415
     C     DDSEIN        ANDEQ     'Y'                                                        263228
     C     NAIPD         ANDEQ     0                                                          263228
     C     NPDIN         ANDGT     0                                                          263228
     C     COBMode       ANDNE     'Y'                                                     AR1078092
     C                   EVAL      DDPDINOK = 'N'                                             263228
     C                   EVAL      Idx += 1                                                   263228
     C                   EVAL      FldNamXAr(Idx) = 'DDPDIN'                                  263228
     C                   EVAL      MsgIdXAr(Idx) = '5045671'                                  263228
     C                   ENDIF                                                                263228
      *                                                                                       263228
      ** Defaulting, if both blanks, Classification date
      ** and Range: Reporting
      *
     C                   IF        DDRCAT = *BLANKS
     C                             AND DDRIDT = *BLANKS
     C                   MOVE      NSDAT         NRIDT
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    NRIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDRIDT
     C                   IF        DDRIDT = '000000'                                        MD020128
     C                   EVAL      DDRIDT = *BLANKS                                         MD020128
     C                   ENDIF                                                              MD020128
     C                   ENDIF
      *
      ** Cross check Classification date and Range: Reporting
      *
     C                   SELECT
      *
      ** ALL entered, check consistency
      *
     C                   WHEN      DDRCAT <> *BLANKS
     C                             AND DDRIDT <> *BLANKS
      *
     C                   Z-ADD     0             WDAYS
     C                   Z-ADD     1             WIDX
      *
     C                   EVAL      WDAYS = BJRDNB - NRIDT
     C                   IF        WDAYS > 999                                              MD020128
     C                   EVAL      WDAYS = 999                                              MD020128
     C                   ENDIF                                                              MD020128
      *
     C                   IF        WDAYS > 999
     C                   EVAL      WDAYS = 999
     C                   EVAL      WIDX = %LOOKUPGT(WDAYS:DSRCN:1) - 1
     C                   ELSE
     C                   EVAL      WIDX = %LOOKUPGE(WDAYS:DSRCN:1)
     C                   ENDIF
      *
     C                   IF        WIDX <> NRCAT
     C                   EVAL      DDRCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045641'
     C                   EVAL      DDRIDTOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRIDT'
     C                   EVAL      MsgIdXAr(Idx) = '5045784'
     C                   ENDIF
      *
      ** ONLY Classification range
      *
     C                   WHEN      DDRCAT <> *BLANKS
     C                             AND DDRIDT = *BLANKS
      *
     C                   Z-ADD     0             WDAYS1
     C                   Z-ADD     0             WDAYS2
      *
      ** Lower limit calculated or defaulted to 0 if 999
      *
     C                   EVAL      WDAYS1 = BJRDNB - DSRCN(NRCAT)
     C                   IF        DSRCN(NRCAT) = 999
     C                   EVAL      WDAYS1 = 0
     C                   ENDIF
      *
      ** Upper limit is today or previous range
      *
     C                   IF        NRCAT = 1
     C                   EVAL      WDAYS2 = BJRDNB
     C                   ELSE
     C                   EVAL      WDAYS2 = BJRDNB - DSRCN(NRCAT-1)
     C                   ENDIF
     C                   SELECT
      *
      ** If Start Date is within range, use it to set
      ** the Initial Date
      *
     C                   WHEN      NSDAT <= WDAYS2
     C                             AND NSDAT > WDAYS1
     C                   EVAL      NRIDT = NSDAT
      *
      ** If Start Date is lower than range, use the beginning
      ** of the range to set the Initial Date
      *
     C                   WHEN      NSDAT <= WDAYS1
     C                   EVAL      NRIDT = WDAYS1
      *
      ** Otherwise, we have an error
      *
     C                   OTHER
     C                   EVAL      DDRCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDRCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045696'
     C                   ENDSL
      *
     C                   IF        DDRCATOK = 'Y'
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    NRIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDRIDT
     C                   IF        DDRIDT = '000000'                                        MD020128
     C                   EVAL      DDRIDT = *BLANKS                                         MD020128
     C                   ENDIF                                                              MD020128
     C                   ENDIF
      *
      ** ONLY Classification Initial Date
      *
     C                   WHEN      DDRCAT = *BLANKS
     C                             AND DDRIDT <> *BLANKS
      *
     C                   Z-ADD     0             WDAYS
      *
     C                   EVAL      WDAYS = BJRDNB - NRIDT
      *
     C                   IF        WDAYS > 999                                              MD020128
     C                   EVAL      WDAYS = 999                                              MD020128
     C                   ENDIF                                                              MD020128
      *                                                                                     MD020128
     C                   IF        WDAYS > 999
     C                   EVAL      WDAYS = 999
     C                   EVAL      NRCAT = %LOOKUPGT(WDAYS:DSRCN:1) - 1
     C                   ELSE
     C                   EVAL      NRCAT = %LOOKUPGE(WDAYS:DSRCN:1)
     C                   ENDIF
     C                   MOVE      NRCAT         DDRCAT
      *
     C                   ENDSL
      *
      ** Defaulting, if both blanks, Classification date
      ** and Range: Basel II
      *
     C                   IF        DDBCAT = *BLANKS
     C                             AND DDBIDT = *BLANKS
     C                   MOVE      NSDAT         NBIDT
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    NBIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDBIDT
     C                   IF        DDBIDT = '000000'                                        MD020128
     C                   EVAL      DDBIDT = *BLANKS                                         MD020128
     C                   ENDIF                                                              MD020128
     C                   ENDIF
      *
      ** Cross check Classification date and Range: Basel II
      *
     C                   SELECT
      *
      ** ALL entered, check consistency
      *
     C                   WHEN      DDBCAT <> *BLANKS
     C                             AND DDBIDT <> *BLANKS
      *
     C                   Z-ADD     0             WDAYS
     C                   Z-ADD     1             WIDX
      *
     C                   EVAL      WDAYS = BJRDNB - NBIDT
     C                   IF        WDAYS > 999                                              MD020128
     C                   EVAL      WDAYS = 999                                              MD020128
     C                   ENDIF                                                              MD020128
      *
     C                   IF        WDAYS > 999
     C                   EVAL      WDAYS = 999
     C                   EVAL      WIDX = %LOOKUPGT(WDAYS:DSBCN:1) - 1
     C                   ELSE
     C                   EVAL      WIDX = %LOOKUPGE(WDAYS:DSBCN:1)
     C                   ENDIF
      *
     C                   IF        WIDX <> NBCAT
     C                   EVAL      DDBCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045642'
     C                   EVAL      DDBIDTOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBIDT'
     C                   EVAL      MsgIdXAr(Idx) = '5045785'
     C                   ENDIF
      *
      ** ONLY Classification range
      *
     C                   WHEN      DDBCAT <> *BLANKS
     C                             AND DDBIDT = *BLANKS
      *
     C                   Z-ADD     0             WDAYS1
     C                   Z-ADD     0             WDAYS2
      *
      ** Lower limit calculated or defaulted to 0 if 999
      *
     C                   EVAL      WDAYS1 = BJRDNB - DSBCN(NBCAT)
     C                   IF        DSBCN(NBCAT) = 999
     C                   EVAL      WDAYS1 = 0
     C                   ENDIF
      *
      ** Upper limit is today or previous range
      *
     C                   IF        NBCAT = 1
     C                   EVAL      WDAYS2 = BJRDNB
     C                   ELSE
     C                   EVAL      WDAYS2 = BJRDNB - DSBCN(NBCAT-1)
     C                   ENDIF
      *
     C                   SELECT
      *
      ** If Start Date is within range, use it to set the Initial Date
      *
     C                   WHEN      NSDAT <= WDAYS2
     C                             AND NSDAT > WDAYS1
     C                   EVAL      NBIDT = NSDAT
      *
      ** If Start Date is lower than range, use the beginning of the
      ** range to set the Initial Date
      *
     C                   WHEN      NSDAT <= WDAYS1
     C                   EVAL      NBIDT = WDAYS1
     C                   OTHER
      *
      ** Otherwise, we have an error
      *
     C                   EVAL      DDBCATOK = 'N'
     C                   EVAL      Idx += 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBCAT'
     C                   EVAL      MsgIdXAr(Idx) = '5045786'
     C                   ENDSL
      *
     C                   IF        DDBCATOK = 'Y'
     C                   CALLB     'ZDATE2'                             H1
     C                   PARM                    NBIDT
     C                   PARM                    BJDFIN
     C                   PARM                    ZDate
     C                   PARM                    Filler
     C                   MOVE      ZDate         DDBIDT
     C                   IF        DDBIDT = '000000'                                        MD020128
     C                   EVAL      DDBIDT = *BLANKS                                         MD020128
     C                   ENDIF                                                              MD020128
     C                   ENDIF
      *
      ** ONLY Classification Initial Date
      *
     C                   WHEN      DDBCAT = *BLANKS
     C                             AND DDBIDT <> *BLANKS
      *
     C                   Z-ADD     0             WDAYS
      *
     C                   EVAL      WDAYS = BJRDNB - NBIDT
     C                   IF        WDAYS > 999                                              MD020128
     C                   EVAL      WDAYS = 999                                              MD020128
     C                   ENDIF                                                              MD020128
      *
     C                   IF        WDAYS > 999
     C                   EVAL      WDAYS = 999
     C                   EVAL      NBCAT = %LOOKUPGT(WDAYS:DSBCN:1) - 1
     C                   ELSE
     C                   EVAL      NBCAT = %LOOKUPGE(WDAYS:DSBCN:1)
     C                   ENDIF
     C                   MOVE      NBCAT         DDBCAT
      *
     C                   ENDSL
      *
      ** Set up NxCSD and NxCDY
      *
     C                   EVAL      NRCSD = NRIDT
     C                   EVAL      NRCDY = 0
      *
     C                   IF        NRCAT > 1
     C                   IF        DSRCN(NRCAT-1) > 0
     C                             AND DSRCN(NRCAT-1) < 999
     C                   EVAL      NRCSD = DSRCN(NRCAT-1)
     C                   EVAL      NRCDY = DSRCE(NRCAT)
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      NBCSD = NBIDT
     C                   EVAL      NBCDY = 0
      *
     C                   IF        NBCAT > 1
     C                   IF        DSRCN(NBCAT-1) > 0
     C                             AND DSRCN(NBCAT-1) < 999
     C                   EVAL      NBCSD = DSRCN(NBCAT-1)
     C                   EVAL      NBCDY = DSRCE(NBCAT)
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
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
     C                   PARM                    TrnDets
     C                   PARM                    BJRDNB
     C                   PARM                    BJDFIN
     C                   PARM                    RecordType
      *
      ** OUTPUTS
      *
     C                   PARM                    ValidPDCL
     C                   PARM                    NBCDY
     C                   PARM                    NBCSD
     C                   PARM                    NRCDY
     C                   PARM                    NRCSD
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** OK values
      *
     C                   PARM                    OKTrnDets
     C                   PARM                    COBMode           1
      *
      ** Retrieve arrays
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
      *
      ** DBERR 001
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCLNDPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Basel II: Classification Period Descriptions
      *
     C                   EVAL      DSBCN(1) = BPCLN1
     C                   EVAL      DSBCN(2) = BPCLN2
     C                   EVAL      DSBCN(3) = BPCLN3
     C                   EVAL      DSBCN(4) = BPCLN4
     C                   EVAL      DSBCN(5) = BPCLN5
     C                   EVAL      DSBCN(6) = BPCLN6
     C                   EVAL      DSBCN(7) = BPCLN7
     C                   EVAL      DSBCN(8) = BPCLN8
     C                   EVAL      DSBCN(9) = BPCLN9
      *
     C     2             DO        9             Ix
     C                   IF        DSBCN(Ix) = 0
     C                   EVAL      DSBCN(Ix) = 999
     C                   ENDIF
     C                   ENDDO
      *
      ** Basel II: No of Days in periods
      *
     C                   EVAL      DSBCE = *ALL'999'
     C                   EVAL      DSBCE(1) = DSBCN(1)
      *
     C     2             DO        9             #A
     C                   IF        DSBCN(#A) > 0 AND
     C                             DSBCN(#A) < 999
     C                   EVAL      DSBCE(#A) = DSBCN(#A) - DSBCN(#A-1)
     C                   ENDIF
     C                   ENDDO
      *
      ** Reporting: Classification Period Descriptions
      *
     C                   EVAL      DSRCN(1) = BPRCN1
     C                   EVAL      DSRCN(2) = BPRCN2
     C                   EVAL      DSRCN(3) = BPRCN3
     C                   EVAL      DSRCN(4) = BPRCN4
     C                   EVAL      DSRCN(5) = BPRCN5
     C                   EVAL      DSRCN(6) = BPRCN6
     C                   EVAL      DSRCN(7) = BPRCN7
     C                   EVAL      DSRCN(8) = BPRCN8
     C                   EVAL      DSRCN(9) = BPRCN9
      *
     C     2             DO        9             Ix
     C                   IF        DSRCN(Ix) = 0
     C                   EVAL      DSRCN(Ix) = 999
     C                   ENDIF
     C                   ENDDO
      *
      ** Reporting: No of Days in periods
      *
     C                   EVAL      DSRCE = *ALL'999'
     C                   EVAL      DSRCE(1) = DSRCN(1)
      *
     C     2             DO        9             #A
     C                   IF        DSRCN(#A) > 0 AND
     C                             DSRCN(#A) < 999
     C                   EVAL      DSRCE(#A) = DSRCN(#A) - DSRCN(#A-1)
     C                   ENDIF
     C                   ENDDO
      *
      ** Program, module and procedure names for DB Error processing
      **
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2012
