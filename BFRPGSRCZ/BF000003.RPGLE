     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     H NOMAIN
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF CCSID Conversion Routines')                   *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000003 - CCSID Conversion Routines                         *
      *                                                               *
      *  Function:  This program provides functionality for           *
      *             CCSID Conversion                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF006             Date 04Jul11               *
      *  Prev Amend No. XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF006 - BF Infrastructure: Initiating BankFusion Services   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
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
      /EJECT
      *
      *---------------------------------------------------------------------------------------
      *  PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000006
      *
      *  Opens an instance of ICONV to convert one CCSID to another CCSID
      *
     D QtqIconvOpen    PR                  extproc('QtqIconvOpen')
     D                                     likeDS(iconv_t)
     D  toCCSID                            likeDS(QtqCode_t)
     D  fromCCSID                          likeDS(QtqCode_t)
      *
      *  Perform conversion from one CCSID to another
      *
     D iconv           PR            10U 0 extproc('iconv')
     D  hconv                              likeDS(iconv_t) value
     D  ptrInBuf                       *   value
     D  inLength                       *   value
     D  ptrOutBuf                      *   value
     D  outLength                      *   value
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  initCCSID - Initialise the CCSID Conversion Descriptor       *
      *                                                               *
      *****************************************************************
      *
     P initCCSID       B                   EXPORT
      *
     D                 PI                  likeDS(iconv_t)
     D  pToCCSID                           likeDS(QtqCode_T)
     D  pFromCCSID                         likeDS(QtqCode_T)
      *
      ** Work fields
      *
     D wRetConv        DS                  likeDS(iconv_t)
     D                                     inz(*LIKEDS)
      *
      /free
 
               wRetConv = QtqIconvOpen(pToCCSID : pFromCCSID);
 
               if wRetConv.return_Value = -1;
               endif;
 
               return wRetConv;
 
      /end-free
     P                 E
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  cvtCCSID - Convert from one CCSID to another                 *
      *                                                               *
      *****************************************************************
      *
     P cvtCCSID        B                   EXPORT
      *
     D                 PI         65535a
     D  pIconv_c                           likeDS(iconv_t)
     D  pPtrData                       *   value
     D  PLength                      10i 0 value
      *
      ** Work fields
      *
     D  wPtrPtrData    S               *
     D  wInLen         S             10I 0
     D  wOutData       S          65535a
     D  wPtrOut        S               *
     D  wPtrPtrOut     S               *
     D  wOutLen        S             10I 0
     D  wRc            S             10U 0
      *
      /free
 
               wPtrPtrData = %addr(pPtrData);
               wInLen = pLength;
               wPtrOut = %addr(wOutData);
               wPtrPtrOut = %addr(wPtrOut);
               wOutLen = %size(wOutData);
 
          // Call the convertor and handle the errors returned
 
               wRc = iconv(pIconv_c
                         : wPtrPtrData
                         : %addr(wInLen)
                         : wPtrPtrOut
                         : %addr(wOutLen)
                         );
 
          // Error returned?
               if wRc = -1;
               endif;
 
          // Return the converted data
               return wOutData;
 
      /end-free
      *
     P                 E
      *
