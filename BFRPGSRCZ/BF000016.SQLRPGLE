     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                   AR1026104A
/*STD *  RPGSQLMOD                                                    *                   AR1026104A
/*EXI *  TEXT('Midas BF Update Business Date')
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000016 - Update Business Date                              *
      *                                                               *
      *  Function:  This program invokes the BF Update Business Date  *
      *             Service by accessing the Web services             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD044342           Date 01Mar17               *
      *  Prev Amend No. AR1026104A         Date 13Sep12               *
      *                 AR884111A *CREATE  Date 25Jan12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD044342 - Business date in BF is not being updated.         *
      *  AR1026104A - Rundates in BFMidas is not insynch with BFTC    *
      *  AR884111A - Update Business Date in BF                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * GetDetails - Subroutine to fetch data from SDBANKPD for the   *
      *              Zone Name and Business Date                      *
      * ConvBDate  - Subroutine to convert the day number received    *
      *              from SDBANKPD into Date Format                   *
      * FmtDetails - Format details into the SOAP Body                *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** +--------------------------------------+
      ** ¦ GLOBAL work fields                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D***wRc****         S                   LIKE(WEB_INT)                                AR1026104A
     D wRc             S             10I 0                                                AR1026104A
      *
     D isURL           S             64A
     D isSpEnvAdd      S            500A
     D isSpXMLBody     S           5000A
     D isSpAction      S            120A
     D isPPath         S             64A
      *
     D wZPrefSVal      S            200A
     D SysValRet       S              7A
      *
     D ZoneName        S              2A
     D PDayNoIn        S              5P 0
     D PDateOutZ9      S              8S 0
     D DateOut         S              8A
     D PRetCodeZ9      S              1  0
     D Temp1           S              5A
     D Temp2           S              3A
     D Temp3           S              8A
     D PYear           S              4A
     D PMonth          S              2A
     D PDay            S              2A
     D NewBDate        S             19A
     D RunDt           S              5P 0                                                AR1026104A
     D ConsDash        C                   CONST('-')
     D ConsTime        C                   CONST('T00:00:00')
      *
     D PRTCD           S              7A
     D POPTN           S              7A
      *
      ** +--------------------------------------+
      ** ¦ DATA STRUCTURE                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     D BFWBCONF      E DS                  EXTNAME(BFWBCONF) DTAARA
      **First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)    DTAARA
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D***/COPY*BFCPYSRC,BF000007***                                                       AR1026104A
      *
      ** +--------------------------------------+
      ** ¦ PROTOTYPE                            ¦
      ** ¦ =========                            ¦
      ** +--------------------------------------+
      *
     D BF000013        PR            10I 0
     D   setURL                      64A
     D   setSpEnvAdd                500A
     D   setSpXMLBody              5000A
     D   setSpAction                120A
     D   setPPath                    64A
      *
     D AOSVALR0        PR                  EXTPGM('AOSVALR0')
     D   P@RTCD                       7A
     D   P@OP01                      20A   CONST
     D   P@VL01                     200A   CONST
     D   P@OP02                      20A   CONST
     D   P@VL02                     200A   CONST
     D   P@OP03                      20A   CONST
     D   P@VL03                     200A   CONST
     D   P@OP04                      20A   CONST
     D   P@VL04                     200A   CONST
     D   P@OP05                      20A   CONST
     D   P@VL05                     200A   CONST
     D   P@OP06                      20A   CONST
     D   P@VL06                     200A   CONST
     D   P@OP07                      20A   CONST
     D   P@VL07                     200A   CONST
     D   P@OP08                      20A   CONST
     D   P@VL08                     200A   CONST
     D   P@OP09                      20A   CONST
     D   P@VL09                     200A   CONST
     D   P@OP10                      20A   CONST
     D   P@VL10                     200A   CONST
      *
      /EJECT
      *
      *
      *
      /free
       // *********************************************************
       //  Initiate BF web service
       // *********************************************************

               exsr GetDetails;
               exsr ConvBDate;
                    AOSVALR0(SysValRet
                          :'BrgMidasSystemPrefix'
                          :wZPrefSVal
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          :' '
                          );
               exsr FmtDetails;

               wRc = BF000013(isURL
                              : isSpEnvAdd
                              : isSpXMLBody
                              : isSpAction
                              : isPPath
                              );

            // HTTP Error returned?
                 if wRc <> 1;
                      if bfcrash = 'Y';
       //                  http_crash();                                                  AR1026104A
                           exsr *PSSR;          //                                        AR1026104A
                      endif;
                 endif;



       // *********************************************************
       //  End Program
       // *********************************************************

               *INLR = '1';
               Return;

      /end-free

      *****************************************************************
      *                                                               *
      *  GetDetails - Subroutine to fetch data from SDBANKPD for the  *
      *               Zone Name and Business Date                     *
      *                                                               *
      *  Called by: Initiate BF web service                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     GetDetails    BEGSR

     C**********         CALL      'AOBANKR0'                                             AR1026104A
     C**********         PARM      *Blanks       PRTCD                                    AR1026104A
     C**********         PARM      '*FIRST '     POPTN                                    AR1026104A
     C*****SDBANK        PARM      SDBANK        DSFDY                                    AR1026104A
     C**********                                                                          AR1026104A
     C**********         EVAL      PDayNoIn = BJRDNB                                      AR1026104A
     C**********                                                                          AR1026104A
     C/exec sql                                                                           AR1026104A
     C+ select BJRDNB                                                                     AR1026104A
     C+ into :RunDt                                                                       AR1026104A
     C+ from SDBANKPD                                                                     AR1026104A
     C/end-exec                                                                           AR1026104A
                                                                                          AR1026104A
     C                   EVAL      PDayNoIn = RunDt                                       AR1026104A

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvBDate - Subroutine to convert the day number received    *
      *              from SDBANKPD into Date Format                   *
      *                                                               *
      *  Called by: Initiate BF web service                           *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     ConvBDate     BEGSR

     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCodeZ9
     C
     C                   MOVE      PDateOutZ9    DateOut
     C
     C                   EVAL      PYear = %SUBST(DateOut:1:4)
     C                   EVAL      PMonth = %SUBST(DateOut:5:2)
     C                   EVAL      PDay = %SUBST(DateOut:7:2)
     C
     C                   EVAL      Temp1 = PYear + ConsDash
     C                   EVAL      Temp2 = PMonth + ConsDash
     C                   EVAL      Temp3 = Temp1 + Temp2
     C                   EVAL      NewBDate = Temp3 + PDay
     C                   EVAL      NewBDate = %trim(NewBDate) +
     C                             ConsTime

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FmtDetails - Format details into the SOAP Body               *
      *                                                               *
      *  Called by: Initiate BF web service                           *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************

     C     FmtDetails    BEGSR

     C                   EVAL      isURL = '/bfweb/services/SetBusDateByZone'
     C                   EVAL      isSpEnvAdd = 'xmlns:att="http://' +
     C                             'www.misys.com/bankfusion/attributes" ' +
     C                             'xmlns:all="http://www.' +
     C                             'misys.com/bankfusion/attributes/all"'
     C                   EVAL      isSpXMLBody = '<soapenv:Body>' +
     C                             '<web:SetBusinessDateByzone' +
     C**********                   'ServiceMFRequest>' +                                    MD044342
     C                             'ServiceMF>' +                                           MD044342
     C                             '<zoneBusinessDate>' +
     C                             '<all:ZONENAME>' + %trim(wZPrefSVal) +
     C                             '</all:ZONENAME>' +
     C                             '<all:NEWBUSINESSDATE>' + NewBDate +
     C                             '</all:NEWBUSINESSDATE>' +
     C                             '</zoneBusinessDate>' +
     C                             '</web:SetBusinessDateByzone' +
     C**********                   'ServiceMFRequest>' +                                    MD044342
     C                             'ServiceMF>' +                                           MD044342
     C                             '</soapenv:Body>'
     C                   EVAL      isSpAction = 'http://SetBusDateBy' +
     C                             'Zone/SetBusDateByZonePortType/' +
     C                             'SetBusinessDateByzone' +
     C                             'ServiceMFRequest'
     C                   EVAL      isPPath = ' '

     C                   ENDSR

      *****************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************

     C     *PSSR         BEGSR
     C                   DUMP
     C                   ENDSR

      *****************************************************************
