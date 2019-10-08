     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2015')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Country')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Midas Standing Data Module                           *
      *                                                               *
      *  SDVCTRY - Validate Country                                   *
      *                                                               *
      *  (c) Finastra International Limited 2015                      *
      *                                                               *
      *  Last Amend No. MD052566           Date 24Jan19               *
      *  Prev Amend No. MD050359           Date 06Apr18               *
      *                 CGL177             Date 11Jan16               *
      *                 CGL157  *CREATE    Date 17Aug15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD052566 - Indicia "CRS Agreement" was not retrieved from    *
      *             the country of tax code table                     *
      *  MD050359 - Input field in the NAHO List of Countries page    *
      *             defaults to US when entered                       *
      *  CGL177 - CRS Reporting Phase 2                               *
      *  CGL157 - CRS Reporting                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D PCtry           S              2A   DIM(30)

      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

      ** External DS for Country Details
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)

      ** External DS for Custoter Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** Non-account Holder Details Data Structure
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
                                                                                              CGL177
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CGL177
                                                                                              CGL177
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                  CGL177
     D                                     PREFIX(DS_)                                        CGL177

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

     D WRUN            S              1
     D DDCTRY          S              2
     D DDCTR1          S              2
     D DDCTR2          S              2
     D DDCTR3          S              2
     D DDCTR4          S              2
     D DDCTR5          S              2
     D DDCTR6          S              2
     D DDCTR7          S              2
     D DDCTR8          S              2
     D DDCTR9          S              2
     D DDOKCTRY        S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PKEY1           S              2
     D DDCUST          S              6
     D DDNAHO          S             10
     D DFCTRY          S              2
     D DFCRSA          S              1
     D PCRSDA          S             60
     D WCNCD           S              2A
     D WCOLC           S              2A
     D @PCTRT          S              2A
     D @PCTRR          S              2A
     D PKey2           S             10A
     D PKySt           S              7A
     D PNAHo           S             10A
     D PBrch           S              3A                                                      CGL177

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Initialization
     C                   EVAL      RetCodeIn = *Blanks
     C                   EVAL      FldNamXAr = *Blanks
     C                   EVAL      MsgIDXAr  = *Blanks
     C                   EVAL      MsgDtaXAr = *Blanks
     C                   EVAL      DDOKCTRY = 'Y'
     C                   EVAL      DFCTRY = *Blanks
     C                   EVAL      Idx = 0

      ** Validation
     C                   EXSR      SRVCTRY

      ** If an error was found, set the return code appropriately
     C                   IF        DDOKCTRY = 'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVCTRY - Validate Country                                    *
      *                                                               *
      *****************************************************************

     C     SRVCTRY       BEGSR

      ** Country is mandatory
     C                   IF        DDCTRY = *Blanks
     C                   EVAL      DDOKCTRY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)
     C                   MOVEL     'USS0640'     MsgIDXAr(Idx)
     C                   ENDIF

      ** Country  must exist on the countries table
     C                   IF        DDCTRY <> *Blanks

     C                   CALL      'AOCTRYR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   PARM      DDCTRY        PKEY1
     C     SDCTRY        PARM      SDCTRY        DSSDY

     C                   IF        PRTCD <> *Blanks
     C                   EVAL      DDOKCTRY = 'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)
     C                   MOVEL     'USS0641'     MsgIDXAr(Idx)
     C                   ELSE                                                               MD050359
     C                   EVAL      DDCTRY = A4CNCD                                          MD050359
     C                   ENDIF
     C                   ENDIF

     C                   IF        %LOOKUP(DDCTRY:PCtry:1:30) <> 0                          MD050359
     C                             AND DDCTRY <> *Blanks                                    MD050359
     C                   EVAL      DDOKCTRY = 'N'                                           MD050359
     C                   ADD       1             Idx                                        MD050359
     C                   MOVEL     'DDCTRY'      FldNamXAr(Idx)                             MD050359
     C                   MOVEL     'USS0642'     MsgIDXAr(Idx)                              MD050359
     C                   ENDIF                                                              MD050359
     C                   IF        Idx = 0
     C                   IF        DDCUST <> *Blanks                                        MD050359
     C                   EVAL      PKey2 = DDCUST                                           MD050359
                                                                                            MD050359
     C                   CALL      'AOCUSTR0'                                               MD050359
     C                   PARM      *Blanks       PRtcd                                      MD050359
     C                   PARM      '*KEY   '     POptn                                      MD050359
     C                   PARM                    PKey2                                      MD050359
     C                   PARM                    PKySt                                      MD050359
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD050359
                                                                                            MD050359
     C                   EVAL      WCOLC = BBCOLC                                           MD050359
     C                   ENDIF                                                              MD050359
                                                                                            MD050359
     C                   IF        DDNAHO <> *Blanks                                        MD050359
     C                   CALL      'AONAHOR0'                                               MD050359
     C                   PARM      *BLANKS       PRtCd                                      MD050359
     C                   PARM      '*KEY   '     POptn                                      MD050359
     C                   PARM      DDNAHO        PNAHo                                      MD050359
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD050359
                                                                                            MD050359
     C                   EVAL      WCOLC = NHCOLC                                           MD050359
     C                   ENDIF                                                              MD050359
                                                                                            MD050359
      ** Get CRS agreement                                                                  MD050359
     C                   EVAL      WCNCD = DDCTRY                                           MD050359
                                                                                            MD050359
     C                   CALL      'AOCTTXR0'                                               MD050359
     C                   PARM      *BLANKS       PRTCD                                      MD050359
     C                   PARM      '*KEY   '     POPTN                                      MD050359
     C**********         PARM      DS_A8LCCD     @PCTRT                            MD050359 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      WCNCD         @PCTRR                                     MD050359
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD050359
                                                                                            MD050359
     C                   IF        PRTCD = '*NRF   '                                        MD050359
     C                   EVAL      WCOLC = *BLANK                                           MD050359
     C                   CALL      'AOCTTXR0'                                               MD050359
     C                   PARM      *BLANKS       PRTCD                                      MD050359
     C                   PARM      '*KEY   '     POPTN                                      MD050359
     C**********         PARM      DS_A8LCCD     @PCTRT                            MD050359 MD052566
     C                   PARM      ##CTRY        @PCTRT                                     MD052566
     C                   PARM      *Blanks       @PCTRR                                     MD050359
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      MD050359
     C                   ENDIF                                                              MD050359
                                                                                            MD050359
     C                   IF        PRTCD = *BLANK                                           MD050359
     C                   EVAL      DFCRSA = EWCRSA                                          MD050359
     C                   ELSE                                                               MD050359
     C                   EVAL      DFCRSA = *Blanks                                         MD050359
     C                   ENDIF                                                              MD050359
                                                                                            MD050359
     C                   EVAL      DFCTRY = DDCTRY
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *Entry        PLIST

      ** INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn

     C                   PARM                    DDCUST
     C                   PARM                    DDNAHO
      ** Country
     C                   PARM                    DDCTRY
     C                   PARM                    PCtry

      ** OUTPUTS
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** Country - OK
     C                   PARM                    DDOKCTRY
     C                   PARM                    DFCTRY
     C                   PARM                    DFCRSA                                     MD050359
                                                                                            MD050359
                                                                                            MD050359
      ** ACCESS BANK DETAILS                                                                MD050359
                                                                                            MD050359
     C                   CALL      'AOBANKR0'                                               MD050359
     C                   PARM      '*DBERR '     PRTCD                                      MD050359
     C                   PARM      '*FIRST '     POPTN                                      MD050359
     C     SDBANK        PARM      SDBANK        DSFDY                                      MD050359
                                                                                            MD050359
      ** DATABASE ERROR                                                                     MD050359
                                                                                            MD050359
     C                   IF        PRTCD <> *Blanks                                         MD050359
     C                   MOVEL     'SDBANKPD'    DBFILE                                     MD050359
     C                   MOVEL     '001'         DBASE                                      MD050359
     C                   MOVEL     POPTN         DBKEY                                      MD050359
     C                   EXSR      *PSSR                                                    MD050359
     C                   ENDIF                                                              MD050359
                                                                                            MD050359
     C                   CALL      'AOCUSTR0'                                               MD050359
     C                   PARM      *BLANKS       Prtcd                                      MD050359
     C                   PARM      '*KEY   '     Poptn                                      MD050359
     C                   PARM      BJCUST        Pkey2                                      MD050359
     C                   PARM                    Pkyst                                      MD050359
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD050359
                                                                                            MD050359
     C                   CALL      'AOBRCHR1'                                               MD050359
     C                   PARM      *BLANKS       Prtcd                                      MD050359
     C                   PARM      '*KEY   '     Poptn                                      MD050359
     C                   PARM      BBBRCD        PBRCH                                      MD050359
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      MD050359

                                                                                            MD052566
      ** Access Customer detail of branch to retrieve country of loation                    MD052566
      *                                                                                     MD052566
     C                   MOVEL     *BLANKS       ##CTRY            3                        MD052566
     C                   IF        PRTCD = *Blanks                                          MD052566
     C                   CALL      'AOCUSTR0'                                               MD052566
     C                   PARM      *BLANKS       PRTCD                                      MD052566
     C                   PARM      '*KEY   '     POPTN                                      MD052566
     C                   PARM      DS_A8BICN     Pkey2                                      MD052566
     C                   PARM      *BLANKS       Pkyst                                      MD052566
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD052566
                                                                                            MD052566
     C                   IF        PRTCD = *BLANKS                                          MD052566
     C                   EVAL      ##CTRY = BBCOLC                                          MD052566
     C                   ENDIF                                                              MD052566
     C                   ENDIF                                                              MD052566

      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRUN = *Blanks
     C                   EVAL      WRUN = 'Y'

     C                   CALLB     'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      ********************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2015
