     h debug   alwnull(*usrctl)
     h copyright('(c) Misys International Banking Systems Ltd. 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RN Zip csv file')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RPGLE/RNGNUZIP - Midas RN Zip csv file                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CRN001  *Create    Date 06Oct05               *
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
 
      /EJECT
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
 
     dRunCmd           pr                  extpgm('QCMDEXC')
     d command                     1000a   const
     d length                        15p 5 const
 
 
      * local variables...
     d pDir            S               *
     d pathName        S            256
     d name            S            256
     d checkCSV        s              3  0
     d checkGZ         s              3  0
     d pRtnCod         s              7
     d tempLen         s             10  0
     d vCmd            s           1000
 
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
 
      * Call GZIP program
     c                   if        pRtnCod     = *Blanks
     c                   if        pval2       = 'Y'
 
      * Open up the directory.
 
     c                   eval      pathName    = %Trim(pVal1)
     c                                         + x'00'
     c                   eval      pDir        = opendir(%addr(pathName))
 
      * If Error in opening the Directory.
     c                   if        pDir        = *NULL
     c                   eval      wDbFile     = 'RNGNUZIP'
     c                   eval      wDBase      = 1
     c                   eval      wDbkey      = 'Can not open directory'
     c                   exsr      *PSSR
     c                   endif
 
      * Read each entry from the directory (in a loop).
     c                   eval      p_DirEnt    = readdir(pDir)
     c                   dow       p_DirEnt   <> *NULL
     c
      * This code can only handle file/dir names under 256 bytes long
      * because thats the size of "name"
     c                   eval      tempLen    = %scan(x'00' : d_name)
     c                   if        tempLen    < 256
 
     c                   eval      checkGZ    = %scan('.gz' : d_name)
     c                   if        checkGZ    =  *Zeros
 
     c                   eval      checkCSV   = %scan('.csv' : d_name)
     c                   if        checkCSV  <> *Zeros
 
     c                   eval      d_name     = %Subst(d_name:1:checkCSV + 3)
     c                                        + ''''
 
     c                   eval      vCmd       = 'Call GZIP '''
     c                                        + %Trim(pVal1)
     c                                        + '/'
     c                                        + %Trim(d_name)
      * Call Zip program
     c                   callp     RunCmd(vCmd : %size(vCmd))
 
     c                   endif
 
     c                   endif
 
     c                   endif
 
     c                   eval      d_name      = *blanks
     c                   eval      p_DirEnt    = readdir(pDir)
     c                   enddo
     c                   endif
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
      *  INZSR  - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Automatically                                     *
      *                                                               *
      *****************************************************************
 
     c     *inzsr        begsr
 
      * Midas System Values
     c                   eval      pValDs      = *blanks
     c                   eval      pValK1      = 'FRSExportDirectory  '
     c                   eval      pValK2      = 'CompressFRSData     '
     c                   eval      pValK3      = *Blanks
     c                   eval      pValK4      = *Blanks
     c                   eval      pValK5      = *Blanks
     c                   eval      pValK6      = *Blanks
     c                   eval      pValK7      = *Blanks
     c                   eval      pValK8      = *Blanks
     c                   eval      pValK9      = *Blanks
     c                   eval      pValK10     = *Blanks
 
     c                   call      'AOSVALR0'
     c                   parm      '*DBERR'      pRtnCod
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
 
