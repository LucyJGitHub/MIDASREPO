     h debug   alwnull(*usrctl)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RN Posting of Timestamp to stream file FTPOK')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RPGLE/RNFMTFTP - Midas RN Posting of FTP Script to INPUT file*
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 10Oct05               *
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
 
     frnftpcpd  o    e             disk    infsr(*pssr)
      *
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      /copy zacpysrc,psds
      /copy rncpysrc,rnpssrdfn
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     d/copy rncpysrc,ifsio_h
 
     dtimeStamp        pr                  extpgm('ZAGENTS')
     d                               19a
 
      * Local variables...
     d pDir            S             10I 0
     d wrdata          S             24A
     d rddata          S             48A
     d flags           S             10U 0
     d mode            S             10U 0
     d vRtnCod         S              7A
     d vTimeStamp      S             19A   inz
     d pStreamFile     S            200A   inz
 
      * Parameters for AOSVALR0 and GPAOSVALR0
     d pValDs          ds
     d  pValK1                       20
     d  pVal1                       200
     d  pValK2                       20
     d  pVal2                       200
     d  pValK3                       20
     d  pVal3                       200
     d  pValK4                       20
     d  pVal4                       200
     d  pValK5                       20
     d  pVal5                       200
     d  pValK6                       20
     d  pVal6                       200
     d  pValK7                       20
     d  pVal7                       200
     d  pValK8                       20
     d  pVal8                       200
     d  pValK9                       20
     d  pVal9                       200
     d  pValK10                      20
     d  pVal10                      200
 
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
 
      * Check Return Code if error
      * Valid Link Path
     c                   if        vRtnCod     = *blanks
 
      * Set Flag and Mode
     c                   eval      flags       =  O_WRONLY
     c                                         +  O_CREAT
     c                                         +  O_TRUNC
 
     c                   eval      mode        =  S_IRWXG
     c                                         +  S_IRWXU
     c                                         +  S_IRWXO
 
     c                   eval      pStreamFile = %Trim(pVal1)
     c                                         + '/'
     c                                         + 'FTPOK.csv'
      * Open Stream File
     c                   eval      pDir        = open(%Trim(pStreamFile):
     c                                                 flags: mode)
 
      * If Error found
     c                   if        pDir        < 0
     c                   eval      wDbFile     = 'RNFTPOK'
     c                   eval      wDBase      = 2
     c                   eval      wDbkey      = 'Can not Open Stream file'
      * close Stream File
     c                   callp     close(pDir)
     c                   exsr      *PSSR
     c                   endif
 
      * Retrieve TimeStamp
     c                   callp     timeStamp(vtimestamp)
 
      * Posting of timestamp to stream file
     c                   eval      wrdata      = vTimeStamp
     c                   callp     write(pDir:%addr(wrdata):%size(wrdata))
 
 
      * close Stream File
     c                   callp     close(pDir)
 
      * If Link Path not found
     c                   else
     c                   eval      wDbFile     = 'RNFTPOK'
     c                   eval      wDBase      = 1
     c                   eval      wDbkey      = 'Invalid Directory'
     c                   exsr      *PSSR
     c                   endif
 
 
     c                   endsr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  closedown -  return to calling Program                       *
      *                                                               *
      *****************************************************************
     c     closedown     begsr
 
     c                   eval      *inlr       = *on
     c                   return
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
 
     c     *inzsr        begsr
 
      * Midas System Values
     c                   eval      pValDs      = *blanks
     c                   eval      pValK1      = 'FRSExportDirectory  '
     c                   eval      pValK2      = *blanks
     c                   eval      pValK3      = *blanks
     c                   eval      pValK4      = *blanks
     c                   eval      pValK5      = *blanks
     c                   eval      pValK6      = *blanks
     c                   eval      pValK7      = *blanks
     c                   eval      pValK8      = *blanks
     c                   eval      pValK9      = *blanks
     c                   eval      pValK10     = *blanks
 
     c                   call      'AOSVALR0'
     c                   parm      '*DBERR'      vRtnCod
     c                   parm                    pValK1
     c                   parm                    pVal1
     c                   parm                    pValK2
     c                   parm                    pVal2
     c                   parm                    pValK3
     c                   parm                    pVal3
     c                   parm                    pValK4
     c                   parm                    pVal4
     c                   parm                    pValK5
     c                   parm                    pVal5
     c                   parm                    pValK6
     c                   parm                    pVal6
     c                   parm                    pValK7
     c                   parm                    pVal7
     c                   parm                    pValK8
     c                   parm                    pVal8
     c                   parm                    pValK9
     c                   parm                    pVal9
     c                   parm                    pValK10
     c                   parm                    pVal10
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
