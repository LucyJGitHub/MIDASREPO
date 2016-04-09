     h debug
     h copyright('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas GO Bulk Update of GZFCLTLVPD: write to drvr')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOFCLV002  - Bulk Update of Global File GZFCLTLVPD           *
      *               Task Split - write records to driver.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CGO001AB           Date 06Aug12               *
      *  Prev Amend No. CLE064             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP015  *CREATE    Date 06Mar09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGO001AB - COB Restructure - GO COB Optimisation Phase 1     *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CGP015 - Task Split of Bulk update of Facilities listview    *
      *                                                               *
      *****************************************************************
 
     ffclty     if   e           k disk    include(fcltyfmf)
     f                                     infsr(*pssr)
 
     ffclvixpd  uf a e           k disk    commit
     f                                     infsr(*pssr)
     f                                     prefix(i_)
     F                                     RENAME(FCLTYFMF: INDEXF)                         CGO001AB
 
     ffclvdvpd  o    e           k disk    rename(fcltyfmf: driverf)
     f                                     commit
     f                                     infsr(*pssr)
     F                                     USROPN                                           CGO001AB
      *====================================================================
 
      * Program Status Data Structure
     d/copy zacpysrc,psds
 
     d inPssr                          n
 
      *====================================================================
 
     C     *entry        plist
     C                   parm                    rectot            7 0
     C                   parm                    rtcode            3
 
     C                   OPEN      FCLVDVPD                                                 CGO001AB
                                                                                            CGO001AB
     c     fcltyK        klist
     c                   kfld                    i_cnum
     c                   kfld                    i_fact
     c                   kfld                    i_fcno
     c                   kfld                    i_rctp
      *====================================================================
 
     c                   exsr      init
 
     c                   exsr      tsplit
 
     c                   exsr      closedown
      *********************************************************************
 
     c     tsplit        begsr
 
      * Load records from master file to driver.
 
     C                   EVAL      *IN81 = *OFF                                             CGO001AB
                                                                                            CGO001AB
     c                   do        rectot
     c                   read      fclty
     c                   if        %eof
     C                   IF        *IN81 = *ON                                              CGO001AB
     c                   eval      rtcode      = 'EOF'
     C                   ELSE                                                               CGO001AB
     C                   EVAL      RTCODE = 'NRF'                                           CGO001AB
     C                   ENDIF                                                              CGO001AB
     c                   leave
     c                   endif
 
     C                   IF        *IN81 = *OFF                                             CGO001AB
     C                   EVAL      RECID = 'A'                                              CGO001AB
     C                   EVAL      PROT = *BLANK                                            CGO001AB
     C                   CALL      'ZAGENTS'                                                CGO001AB
     C                   PARM                    TMST                                       CGO001AB
     c                   write     driverf
     C                   EVAL      *IN81 = *ON                                              CGO001AB
     C                   ENDIF                                                              CGO001AB
                                                                                            CGO001AB
     c                   enddo
                                                                                            CGO001AB
     C                   IF        *IN81 = *ON                                              CGO001AB
     C                   EVAL      RECID = 'Z'                                              CGO001AB
     C                   EVAL      PROT = *BLANK                                            CGO001AB
     C                   CALL      'ZAGENTS'                                                CGO001AB
     C                   PARM                    TMST                                       CGO001AB
     C                   WRITE     DRIVERF                                                  CGO001AB
 
      * Update (or write to) index file to reflect last record processed.
 
     c     *start        setll     fclvixpd
     c                   read      fclvixpd
     C                   EVAL      I_RECID = RECID                                          CGO001AB
     c                   eval      i_cnum      = cnum
     c                   eval      i_fact      = fact
     c                   eval      i_fcno      = fcno
     c                   eval      i_rctp      = rctp
     C                   EVAL      I_PROT = PROT                                            CGO001AB
     C                   EVAL      I_TMST = TMST                                            CGO001AB
 
     c                   if        %eof
     c**********         write     fclvixpdf                                                CGO001AB
     C                   WRITE     INDEXF                                                   CGO001AB
     c                   else
     c**********         update    fclvixpdf                                                CGO001AB
     C                   UPDATE    INDEXF                                                   CGO001AB
     c                   endif
                                                                                            CGO001AB
     C                   ENDIF                                                              CGO001AB
 
     c                   commit
 
     c                   endsr
      *********************************************************************
 
     c     init          begsr
 
      * Read the index record to determine start position on master file.
 
     C     *START        SETLL     FCLVIXPD                                                 CGO001AB
     c                   read      fclvixpd
     c                   if        %eof
     c     *start        setll     fclty
     c                   else
     c     fcltyK        setgt     fclty
     c                   endif
 
     c                   endsr
      *********************************************************************
 
     c     closedown     begsr
 
     C                   CLOSE     FCLVDVPD                                                 CGO001AB
     c**********         eval      *inlr       = *on                                        CGO001AB
     c                   return
 
     c                   endsr
      *********************************************************************
 
     C     *pssr         begsr
 
     C                   if        not inPssr
     C                   eval      inPssr      = *on
     C                   dump
     C                   endif
 
     c                   eval      *inlr       = *on
     c                   eval      *inu7       = *on
     C                   eval      *inu8       = *on
     C                   return
 
     C                   endsr
