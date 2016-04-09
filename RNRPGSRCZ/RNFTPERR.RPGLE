     h debug   alwnull(*usrctl)
     h fixnbr(*zoned : *inputpacked)
     h copyright('(c) misys international banking systems ltd. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Check FTP Errors in Transmission')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNFTPERR   - Check FTP Errors in Transmission                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 07Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     frnftplpd  if   e             disk    recno(rcdnbr)
 
     frnftpnpd  if   e             disk
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     d                 ds
     d fclog
     d  firstChar                     1    overlay(fclog)
     d  logNbr                        3    overlay(fclog)
     d  logNbrChk                     4    overlay(fclog)
 
     d aCode           s              3    dim(5)
 
     d error           s               n
     d elm             s              5u 0
     d rcdnbr          s              5u 0
     d msgKey          s              4
     d err             s            100
     d msg             s            200    inz('FRS FTP process has stopped +
     d                                     with the following error -')
 
     d sndPgmMsg       pr                  extpgm('QMHSNDM')
     d  msgId                         7    const
     d  qualMsgFil                   20    const
     d  msgData                     200    const
     d  lenMsgData                   10u 0 const
     d  msgType                      10    const
     d  listMsgQ                     20    const
     d  nbrMsgQ                      10u 0 const
     d  rplyMsgQ                     20    const
     d  msgKey                        4
     d  err                         100
 
      *=====================================================================
 
     irnftpnpdf
     i              code1                       aCode(1)
     i              code2                       aCode(2)
     i              code3                       aCode(3)
     i              code4                       aCode(4)
     i              code5                       aCode(5)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    error
 
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
 
     c                   exsr      main
 
     c                   exsr      closedown
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  main   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
 
     c     main          begsr
 
      * This program checks RNFTPLPD and RNFTPNPD to see
      *  if there was error during transmission.
 
      * Check first char of entries in server FTP log file (RNFTPLPD),
      *  errors are in the 400-500 range.
     c     *start        setll     rnftplpd
     c                   read      rnftplpd
 
     c                   dow       not %eof(rnftplpd)
 
      * Error found, send message and exit
      * Check additionally that there is a space after the first three numbers.
      * Otherwise the 'error' message could be something like '432345 bytes transmitted
      * successfully'!
     c                   if        (firstChar = '4'
     c                             or firstChar = '5') AND
     c                             (%trim(logNbr)=%trim(logNbrChk))
     c                   exsr      sndErrMsg
     c                   endif
 
     c                   read      rnftplpd
     c                   enddo
 
      * Check client errors by reading patterns in RNFTPNPD.
     c     *start        setll     rnftpnpd
     c                   read      rnftpnpd
 
     c                   dow       not %eof(rnftpnpd)
     c                   eval      command     = '> '
     c                                         + %trim(command)
 
      * Search command in FTP log file.
     c     *start        setll     rnftplpd
     c                   read      rnftplpd
     c                   dow       not %eof(rnftplpd)
 
      * If match was found, check each pattern.
     c                   if        %scan(%trimr(command): fclog)
     c                                 > 0
     c                   for       elm         = 1 to %elem(aCode)
     c                   if        aCode(elm)  = *blanks
     c                   leave
     c                   endif
 
     c                   read      rnftplpd
 
     c                   if        logNbr     <> aCode(elm) and
     c                             (%trim(logNbr)=%trim(logNbrChk))
     c                   exsr      sndErrMsg
     c                   endif
     c                   endfor
 
     c                   endif
 
     c                   read      rnftplpd
     c                   enddo
 
 
     c                   read      rnftpnpd
     c                   enddo
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  sndErrMsg -  Send error message to MOPERQ                    *
      *                                                               *
      *****************************************************************
 
     c     sndErrMsg     begsr
 
     c                   eval      error       = *on
     c                   eval      msg         = %trimr(msg)
     c                                         + ' '
     c                                         + %trimr(fclog)
     c                                         + '. See FTP log RNFTPLPD - '
     c                                         + 'line '
     c                                         + %editc(rcdnbr: 'X')
 
     c                   callp     sndPgmMsg('CPF9898'
     c                                     : 'QCPFMSG   *LIBL'
     c                                     : msg
     c                                     : %len(%trimr(msg))
     c                                     : '*INFO'
     c                                     : 'MOPERQ    *LIBL'
     c                                     : 1
     c                                     : *blank
     c                                     : msgKey
     c                                     : err  )
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  closedown -  Return to Calling Program                       *
      *                                                               *
      *****************************************************************
 
     c     closedown     begsr
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
 
     c     *inzsr        begsr
 
      * Set error indicator to false.
     c                   eval      error       = *off
 
     c                   endsr
