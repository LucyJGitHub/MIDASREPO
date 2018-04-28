     h debug
     h copyright('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Universal transactions upd, cloan - write to drvr')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCL002   - Universal transactions update, Customer Loans   *
      *               Task Split - write records to driver.           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. AR1056838          Date 15Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CGO001AC           Date 06Aug12               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP014  *CREATE    Date 27Feb09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1056838 - Task Split's driver file use 6numeric for LNRF.  *
      *              Change LNRF from 6S0 to 6A to comply w/ Alpha    *
      *              Loan Reference Enhancement (Recompile)           *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CGO001AC - COB Restructure - GO COB Optimisation Phase 1     *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CGP014 - Task split of Extract Controller, Customer Loans    *
      *                                                               *
      *****************************************************************
 
     fcloan     if   e           k disk    include(cloanclf)
     f                                     infsr(*pssr)
 
     fxclnixpd  uf a e           k disk    commit
     F                                     RENAME(xclndvd0: indexf)                         CGO001AC
     f                                     infsr(*pssr)
     f                                     prefix(i_)
 
     f***xclndvpd  o    e           k disk    rename(cloanclf: driverf)                     CGO001AC
     FXCLNDVPD  O    E           K DISK    RENAME(xclndvd0: driverf)                        CGO001AC
     f                                     commit
     f                                     infsr(*pssr)
     f                                     USROPN                                           CGO001AC
      *====================================================================
 
      * Program Status Data Structure
     d/copy zacpysrc,psds
 
     d inPssr                          n
     D FirstRec        S              1A                                                    CGO001AC
     D Tmst            S               Z                                                    CGO001AC
 
      *====================================================================
 
     C     *entry        plist
     C                   parm                    rectot            7 0
     C                   parm                    rtcode            3
 
     C                   OPEN      xclndvpd                                                 CGO001AC
                                                                                            CGO001AC
     c     cloanK        klist
     c                   kfld                    i_lnrf
     c                   kfld                    i_rcdt
      *====================================================================
 
     c                   exsr      init
 
     c                   exsr      tsplit
 
     c                   exsr      closedown
      *********************************************************************
 
     c     tsplit        begsr
 
     C                   EVAL      FirstRec = 'Y'                                           CGO001AC
                                                                                            CGO001AC
      * Load records from accounts master to driver.
 
     c                   do        rectot
     c                   read      cloan
     c                   if        %eof
     C                   IF        FirstRec = 'Y'                                           CGO001AC
     C                   EVAL      Rtcode = 'NRF'                                           CGO001AC
     C                   ELSE                                                               CGO001AC
     c                   eval      rtcode      = 'EOF'
     C                   ENDIF                                                              CGO001AC
     c                   leave
     c                   endif
 
      ** Write first record to driver file, if there is one                                 CGO001AC
                                                                                            CGO001AC
     C                   IF        FirstRec = 'Y'                                           CGO001AC
     C                   EVAL      RecId = 'A'                                              CGO001AC
     C                   EVAL      Prot = ' '                                               CGO001AC
                                                                                            CGO001AC
      ** Output Timestamp                                                                   CGO001AC
                                                                                            CGO001AC
     C                   CALL      'ZAGENTS'                                                CGO001AC
     C                   PARM                    Tmst                                       CGO001AC
     c                   write     driverf
     C                   EVAL      FirstRec = 'N'                                           CGO001AC
     C                   ENDIF                                                              CGO001AC
     c                   enddo
                                                                                            CGO001AC
      ** Write last record, if there is one                                                 CGO001AC
                                                                                            CGO001AC
     C                   IF        FirstRec = 'N'                                           CGO001AC
     C                   EVAL      RecId       = 'Z'                                        CGO001AC
     C                   EVAL      Prot        = ' '                                        CGO001AC
     C                   CALL      'ZAGENTS'                                                CGO001AC
     C                   PARM                    Tmst                                       CGO001AC
     C                   WRITE     driverf                                                  CGO001AC
     C                   ENDIF                                                              CGO001AC
 
      * Update (or write to) index file to reflect last account processed.
 
     c     *start        setll     xclnixpd
     c                   read      xclnixpd
     C                   EVAL      i_recid = RecId                                          CGO001AC
     c                   eval      i_lnrf      = lnrf
     c                   eval      i_rcdt      = rcdt
     C                   EVAL      i_prot = Prot                                            CGO001AC
     C                   EVAL      i_tmst = Tmst                                            CGO001AC
 
     c                   if        %eof
     c**********         write     xclnixpdf                                                CGO001AC
     C                   WRITE     indexf                                                   CGO001AC
     c                   else
     c**********         update    xclnixpdf                                                CGO001AC
     C                   UPDATE    indexf                                                   CGO001AC
     c                   endif
 
     c                   commit
 
     c                   endsr
      *********************************************************************
 
     c     init          begsr
 
     C     *START        SETLL     xclnixpd                                                 CGO001AC
                                                                                            CGO001AC
      * Read the index record to determine start position on customer loans file.
 
     c                   read      xclnixpd
     c                   if        %eof
     c     *start        setll     cloan
     c                   else
     c     cloanK        setgt     cloan
     c                   endif
 
     c                   endsr
      *********************************************************************
 
     c     closedown     begsr
 
     C                   CLOSE     xclndvpd                                                 CGO001AC
     c**********         eval      *inlr       = *on                                        CGO001AC
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
