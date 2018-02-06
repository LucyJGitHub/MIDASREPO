     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2017')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Purge Soft-Deleted Entries in BFP Tables')    *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF004019 - Purge Soft-Deleted Entries in BFP Tables          *
      *                                                               *
      *  Function:  This program invokes the BF Batch Process Purge   *
      *             Service by accessing the Web services             *
      *                                                               *
      *  (c) Finastra International Limited 2017                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CBF023  *CREATE    Date 04Jan17               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CBF023 - Soft Delete Feature on Security Related Modules     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
     D wRc             S             10I 0
      *
     D isURL           S             64A
     D isSpEnvAdd      S            500A
     D isSpXMLBody     S           5000A
     D isSpAction      S            120A
     D isPPath         S             64A
      *
      ** +--------------------------------------+
      ** ¦ DATA STRUCTURE                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
     D BFWBCONF      E DS                  EXTNAME(BFWBCONF) DTAARA
      *
      ** +--------------------------------------+
      ** ¦ PROTOTYPE                            ¦
      ** ¦ =========                            ¦
      ** +--------------------------------------+
      *
     D BF004020        PR            10I 0
     D   setURL                      64A
     D   setSpEnvAdd                500A
     D   setSpXMLBody              5000A
     D   setSpAction                120A
     D   setPPath                    64A
      *
      /EJECT
      *
      *
      *
      /free
       // *********************************************************
       //  Initiate BF web service
       // *********************************************************
 
               exsr FmtDetails;
 
               wRc = BF004020(isURL
                              : isSpEnvAdd
                              : isSpXMLBody
                              : isSpAction
                              : isPPath
                              );
 
            // HTTP Error returned?
                 if wRc <> 1;
                      if bfcrash = 'Y';
 
                           exsr *PSSR;
                      endif;
                 endif;
 
       // *********************************************************
       //  End Program
       // *********************************************************
 
               *INLR = '1';
               Return;
 
      /end-free
 
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
 
     C                   EVAL      isURL = '/bfweb/services/BatchProcess' +
     C                             'PurgingWS'
     C                   EVAL      isSpEnvAdd = 'xmlns:att="http://' +
     C                             'www.misys.com/bankfusion/attributes"'
     C                   EVAL      isSpXMLBody = '<soapenv:Body>' +
     C                             '<web:BatchProcessPurgingMF/>' +
     C                             '</soapenv:Body>'
     C                   EVAL      isSpAction = 'http://BatchProcess' +
     C                             'PurgingWS/BatchProcessPurgingWS' +
     C                             'PortType/BatchProcessPurging' +
     C                             'MFRequest'
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
