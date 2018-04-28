     h debug   alwnull(*usrctl)
     h copyright('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Update T__BOOKCNT file')
      *****************************************************************
      *                                                               *
      *  MidasPlus - FRS Regulatory Reporting Interface               *
      *                                                               *
      *  RNBKCTUP  - Update T__BOOKCNT file                           *
      *                                                               *
      *  Function:  This program is created to update fields          *
      *             INTPARRE and BOOCNTRE in each record of table     *
      *             T__BOOKCNT.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 03May06               *
      *  Prev Amend No. BUG9715 *CREATE    Date 12Jan06               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion of customer number to alpha (post       *
      *            build 103). Recompiled.                            *
      *  BUG9715 - T_bookCNT field INTPARRE rejected by IFS.          *
      *                                                               *
      *****************************************************************
     fT__BOOKCNTUF   E             DISK    INFSR(*PSSR)
     f                                     RENAME(t__BOOKCNT:BOOKCNTF)
     f                                     USROPN
      *
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      /COPY ZACPYSRC,PSDS
      /COPY RNCPYSRC,RNPSSRDFN
 
     d CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** parameters for 'GOGETZONE'
     d pRtnCod         s              7
     d pErrMsg         s             50
     d pFullChk        s              1
     d pZone           s             10
     d pShtc           s              4
     d pRdnb           s              5  0
     d pDnwd           s              5  0
     d pBccy           s              3
     d pNjob           s              1  0
      *
     d pOption         s              7
     d pBrcd           s              3
     d dsfdy         e ds
     d sdbrch        e ds                  extname(sdbrchpd)
     d  qqdfacx      e                     extfld(qqdfac)
      *
     d pKey1           s             10
     d pKyst           s              7
     d dssdy         e ds                  extname(dssdy)
     d sdcust        e ds                  extname(sdcustpd)
      *
     d WZone           S                   LIKE(A8ZONE)
     d WBrcd           S                   LIKE(BBBRCD)
     d WBicn           S                   LIKE(A8BICN)
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
      *  MAIN   -  Main subroutine                                    *
      *                                                               *
      *****************************************************************
 
     c     main          begsr
      *
      ** Update each record in file T__BOOKCNT
     c                   OPEN      T__BOOKCNT
      *
     c                   READ      T__BOOKCNT
     c                   DOW       not %EOF
      *
     c                   EVAL      %SUBST(BOOCNTRE:1:10) = WZone
     c                   EVAL      INTPARRE = WBrcd + '-' + WBicn
     c                   UPDATE    BOOKCNTF
      *
     c                   READ      T__BOOKCNT
     c                   ENDDO
      *
     c                   CLOSE     T__BOOKCNT
      *
     c                   endsr
      *
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
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * called by: Implicitly on program activation                   *
      *                                                               *
      *****************************************************************
     c     *inzsr        begsr
 
      ** Get zone.
     c                   callb     'GOGETZONE'
     c                   parm      *blanks       pRtnCod
     c                   parm      *blanks       pErrMsg
     c                   parm      'N'           pFullChk
     c                   parm      *blanks       pZone
     c                   parm                    pShtc
     c                   parm                    pRdnb
     c                   parm                    pDnwd
     c                   parm                    pBccy
     c                   parm                    pNjob
 
     c                   if        pRtnCod    <> *blanks
     c                   eval      wDbfile     = 'GPZONEPD'
     c                   eval      wDbase      = 1
     c                   eval      wDbkey      = pZone
     c                   exsr      *pssr
     c                   endif
 
     c                   eval      WZone       = pZone
 
      ** Get first branch details for internal customer number.
     c                   callb     'AOBRCHR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm      '*FIRST '     pOption
     c                   parm                    pbrcd
     c     sdbrch        parm                    dsfdy
 
     c                   eval      WBicn       = A8Bicn
 
      ** Get customer details of the branch internal customer number.
     c                   callb     'AOCUSTR0'
     c                   parm      '*DBERR'      pRtnCod
     c                   parm      '*KEY'        pOption
     c                   parm      WBicn         pKey1
     c                   parm                    pKyst
     c     sdcust        parm                    dssdy
 
     c                   eval      WBrcd       = BBBRCD
 
     c                   endsr
 
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
**ctdata cpy@
(c) Misys International Banking Systems Ltd. 2005
