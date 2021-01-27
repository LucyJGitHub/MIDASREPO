     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UT000022F) TOFILE(UPFFDSTPD)                     *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT ADBU write log file')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000039 - ADBU write log file                               *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE   Date 17Mar20               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     FUPCLOGPD  O  A E             DISK

     C     *ENTRY        PLIST
     C                   PARM                    #LIB1            10
     C                   PARM                    #LIB2            10
     C                   PARM                    #FILE            10
     C                   PARM                    #FATR             4
     C                   PARM                    #NARR            10
     C                   PARM                    #FIELD           10
     C                   PARM                    #RPGN             6
     C                   PARM                    #DESC            50
     C                   PARM                    #DAT             40
     C                   PARM                    DSP              40
     C                   PARM                    #WHDS           132
     C                   PARM                    #JOB             10

     C                   CLEAR                   UPCLOGD0

     C                   EVAL      WJOB = #JOB
     C                   Select
     C                   When      #FATR = 'DTAA'
     C                   IF        #NARR = 'NOT FOUND'
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = #FATR
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = *BLANKS
     C                   IF        #LIB2 = *BLANKS
     C                   EVAL      WDESC = 'DTAARA missing'
     C                   ELSE
     C                   EVAL      WDESC = 'New DTAARA'
     C                   endif
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   else
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = #FATR
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = *BLANKS
     C                   EVAL      WDESC = 'DTAARA different'
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   endif

     C                   When      #FATR = 'DTAQ'
     C                   IF        #NARR = 'NOT FOUND'
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = #FATR
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = *BLANKS
     C                   IF        #LIB2 = *BLANKS
     C                   EVAL      WDESC = 'DTAQ missing'
     C                   ELSE
     C                   EVAL      WDESC = 'New DTAQ'
     C                   endif
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   else
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = #FATR
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = *BLANKS
     C                   EVAL      WDESC = 'DTAQ different'
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   endif

     C                   Other
     C                   IF        #NARR = 'NOT FOUND'
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = #FATR
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = *BLANKS
     C                   EVAL      WFLDA = *BLANKS
     C                   IF        #LIB2 = *BLANKS
     C                   EVAL      WDESC = 'File missing'
     C                   ELSE
     C                   EVAL      WDESC = 'New file'
     C                   endif
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDATA = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = *BLANKS
     C                   WRITE     UPCLOGD0
     C                   ELSE
     C                   EVAL      WFILE = #FILE
     C                   EVAL      WTYPE = *BLANKS
     C                   IF        #NARR = 'Rmv field'
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WFLD1 = #FIELD
     C                   EVAL      WFLD2 = *BLANKS
     C                   endif
     C                   IF        #NARR = 'New field'
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLD1 = *BLANKS
     C                   EVAL      WFLD2 = #FIELD
     C                   endif
     C                   IF        #NARR = 'New field'
     C                             or #NARR = 'Rmv field'
     C                   EVAL      WDESC = #NARR
     C                   EVAL      WFLDA = *BLANKS
     C                   EVAL      WFDEC = *BLANKS
     C                   EVAL      WDSP  = *BLANKS
     C                   EVAL      WWHDS = #WHDS
     C                   ELSE
     C                   EVAL      WLIB1 = #LIB1
     C                   EVAL      WLIB2 = #LIB2
     C                   EVAL      WFLDA = #RPGN
     C                   EVAL      WDESC = *BLANKS
     C                   EVAL      WFDEC = #DESC
     C                   EVAL      WDSP  = DSP
     C                   EVAL      WWHDS = *BLANKS
     C                   IF        #RPGN = 'ATTXT'
     C                   EVAL      WWHDS = #WHDS
     C                   else
     C                   EVAL      WWHDS = *BLANKS
     C                   endif
     C                   EVAL      WFLD1 = #FIELD
     C                   EVAL      WFLD2 = #FIELD
     C                   ENDIF
     C                   EVAL      WDATA = #DAT
     C                   WRITE     UPCLOGD0
     C                   ENDIF

     C                   Endsl

     C                   SETON                                        LR
     C                   RETURN
