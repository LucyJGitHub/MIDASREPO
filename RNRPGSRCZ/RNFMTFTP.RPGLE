     h debug   alwnull(*usrctl)
     h copyright('(c) Finastra International Limited 2005')
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RN Posting of FTP Script to INPUT file')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RPGLE/RNFMTFTP - Midas RN Posting of FTP Script to INPUT file*
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRN001  *CREATE    Date 05Oct05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     frnftpcpd  o    e             disk    infsr(*pssr)
 
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
 
     d pDir            S               *
     d PathName        S            256
     d Name            S            256
     d CheckCSV        s              3  0
     d CheckGZ         s              3  0
     d vRtnCod         s              7
     d xRtnCod         s              7
     d pRtnCd          s              7
     d tempLen         s             10  0
 
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
     d  pValK11                      20
     d  pVal11                      200
     d  pValK12                      20
     d  pVal12                      200
     d  pValK13                      20
     d  pVal13                      200
     d  pValK14                      20
     d  pVal14                      200
     d  pValK15                      20
     d  pVal15                      200
     d  pValK16                      20
     d  pVal16                      200
     d  pValK17                      20
     d  pVal17                      200
     d  pValK18                      20
     d  pVal18                      200
     d  pValK19                      20
     d  pVal19                      200
     d  pValK20                      20
     d  pVal20                      200
 
      /copy rncpysrc,ifsio_h
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Declaratives                         ¦
      ** ¦ ============                         ¦
      ** +--------------------------------------+
 
     c     *entry        plist
     c                   parm                    pRtnCd
 
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
 
      * write each FTP command to file
      * Check UserLogin and Password
     c                   if            vRtnCod = *blanks
     c                             and xRtnCod = *blanks
     c                             and pVal5  <> *blanks
     c                             and pVal6  <> *blanks
     c                   eval      fccmd       = %trim(pVal5)
     c                                         + ' '
     c                                         + %trim(pVal6)
     c                   write     rnftpcpdf
     c                   else
     c                   eval      wDbFile     = 'rnftpcpd'
     c                   eval      wDBase      = 001
     c                   eval      wDbkey      = pValk5
     c                                         + pValk6
     c                   exsr      *pssr
     c                   endif
 
      * Check Ftp Options
      * -----------------
 
      * Check FtpOption1
     c                   if        pVal7      <> *blanks
     c                   eval      fccmd       = %trim(pVal7)
     c                   write     rnftpcpdf
     c                   endif
 
      * Check FtpOption2
     c                   if        pVal8      <> *blanks
     c                   eval      fccmd       = %trim(pVal8)
     c                   write     rnftpcpdf
     c                   endif
 
      * Check FtpOption3
     c                   if        pVal9      <> *blanks
     c                   eval      fccmd       = %trim(pVal9)
     c                   write     rnftpcpdf
     c                   endif
 
      * Check FtpOption4
     c                   if        pVal10     <> *blanks
     c                   eval      fccmd       = %trim(pVal10)
     c                   write     rnftpcpdf
     c                   endif
 
      * Check FtpOption5
     c                   if        pVal11     <> *blanks
     c                   eval      fccmd       = %trim(pVal11)
     c                   write     rnftpcpdf
     c                   endif
 
      * If the whole data transport mechanism has been successful, format FTP command file to send
      * the FTPOK file
 
     c                   if        pRtnCd      = 'FTPOK'
 
     c                   if            pVal1  <> *blank
     c                             and pVal2  <> *blank
     c                   eval      fccmd       = 'PUT'
     c                                         + ' '
     c                                         + %trim(pVal1)
     c                                         + '/'
     c                                         + 'FTPOK.csv'
     c                                         + ' '
     c                                         + %trim(pVal2)
     c                                         + '/'
     c                                         + 'FTPOK.csv'
     c                   write     rnftpcpdf
     c                   else
     c                   eval      wDbFile     = 'rnftpcpd'
     c                   eval      wDBase      = 007
     c                   eval      wDbkey      = pValk1
     c                                         + pValk2
     c                   exsr      *pssr
     c                   Endif
 
      * Use IFS APIs to open the FRS Export directory, read each directory entry and
      * write out a series of PUT commands, from the export directory to the target directory
     c                   else
 
     c                   eval      PathName    = %trim(pVal1)
     c                                         + x'00'
     c                   eval      pDir        = opendir(%addr(PathName))
 
      * If Error in opening the Directory.
     c                   if        pDir        = *NULL
     c                   eval      wDbFile     = 'rnftpcpd'
     c                   eval      wDBase      = 8
     c                   eval      wDbkey      = 'Cannot open Directory'
     c                   exsr      *pssr
     c                   endif
 
      * Read each entry from the directory (in a loop).
     c                   eval      p_DirEnt    = readdir(pDir)
 
     c                   dow       p_DirEnt   <> *NULL
 
      * This code can only handle file/dir names under 256 bytes long
      * because thats the size of "Name"
     c                   eval      tempLen     = %scan(x'00' : d_name)
     c                   if        tempLen < 256
 
     c                   if            (pVal1  <> *blank)
     c                             and (pVal2  <> *blank)
     c                             and (pRtnCd <> 'FTPOK')
 
     c                   eval      Name         = %subst(d_name: 1: d_namelen)
     c                   if        Name<>*blank
     c                             and Name <> '.'
     c                             and Name <> '..'
 
     c                   eval      fccmd        = 'PUT'
     c                                          + ' '
     c                                          + %trim(pVal1)
     c                                          + '/'
     c                                          + %trim(Name)
     c                                          + ' '
     c                                          + %trim(pVal2)
     c                                          + '/'
     c                                          + %trim(Name)
     c                   write     rnftpcpdf
     c                   endif
 
     c                   else
     c                   eval      wDbFile      = 'rnftpcpd'
     c                   eval      wDBase       = 009
     c                   eval      wDbkey       = pRtnCd
     c                                          + 'is not equal to FTPOK.csv'
     c                   exsr      *pssr
     c                   endif
 
     c                   endif
 
      * Read Next file
     c                   eval      d_name      = *blanks
     c                   eval      p_DirEnt    = readdir(pDir)
 
     c                   enddo
 
     c                   endif
 
      * End Session
     c                   if        pVal12     <> *blanks
     c                   eval      fccmd       = %trim(pVal12)
     c                   write     rnftpcpdf
 
     c                   else
     c                   eval      wDbFile     = 'rnftpcpd'
     c                   eval      wDBase      = 010
     c                   eval      wDbkey      = pValk12
     c                   exsr      *pssr
     c                   endif
 
     C                   endsr
 
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
     c/EJECT
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
     c                   eval      pValK2      = 'FRSTargetDirectory  '
     c                   eval      pValK3      = 'CompressFRSData     '
     c                   eval      pValK4      = 'FTPConnection       '
     c                   eval      pValK5      = 'FTPUserLogin        '
     c                   eval      pValK6      = 'FTPUserPassword     '
     c                   eval      pValK7      = 'FTPOption1          '
     c                   eval      pValK8      = 'FTPOption2          '
     c                   eval      pValK9      = 'FTPOption3          '
     c                   eval      pValK10     = 'FTPOption4          '
 
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
 
     c                   eval      pValK11     = 'FTPOption5          '
     c                   eval      pValK12     = 'FTPEndSession       '
     c                   eval      pValK13     = *blanks
     c                   eval      pValK14     = *blanks
     c                   eval      pValK15     = *blanks
     c                   eval      pValK16     = *blanks
     c                   eval      pValK17     = *blanks
     c                   eval      pValK18     = *blanks
     c                   eval      pValK19     = *blanks
     c                   eval      pValK20     = *blanks
 
     c                   call      'AOSVALR0'
     c                   parm      '*DBERR'      xRtnCod
     c                   parm                    pValK11
     c                   parm                    pVal11
     c                   parm                    pValK12
     c                   parm                    pVal12
     c                   parm                    pValK13
     c                   parm                    pVal13
     c                   parm                    pValK14
     c                   parm                    pVal14
     c                   parm                    pValK15
     c                   parm                    pVal15
     c                   parm                    pValK16
     c                   parm                    pVal16
     c                   parm                    pValK17
     c                   parm                    pVal17
     c                   parm                    pValK18
     c                   parm                    pVal18
     c                   parm                    pValK19
     c                   parm                    pVal19
     c                   parm                    pValK20
     c                   parm                    pVal20
 
     c                   endsr
 
      *********************************************************************
      /EJECT
      *********************************************************************
      /copy rncpysrc,rnpssrsr
      *****************************************************************
 
