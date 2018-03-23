     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas LE Facilities Bankruptcy Extract Program')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000497 - Midas LE Facilities Bankruptcy Extract Program    *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CLE168  *Create    Date 26Feb18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE168 - Allow Debit of Blocked Account                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
     D/COPY ZACPYSRC,PROCPARMS
      *
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
     C/EXEC SQL

     C+ INSERT INTO LEFCBKPP
     C+ SELECT DISTINCT FCUS AS CUSTOMER, CONCAT(CASE
     C+ WHEN LENGTH(TRIM(CAST(FTYP AS VARCHAR(3)))) = 1
     C+ THEN CONCAT('00',FTYP)
     C+ WHEN LENGTH(TRIM(CAST(FTYP AS VARCHAR(3)))) = 2
     C+ THEN CONCAT('0',FTYP)
     C+ WHEN LENGTH(TRIM(CAST(FTYP AS VARCHAR(3)))) = 3
     C+ THEN SUBSTR(FTYP,1,3) END,
     C+ CASE WHEN LENGTH(TRIM(CAST(FSEQ AS VARCHAR(2)))) = 1
     C+ THEN CONCAT('0',FSEQ)
     C+ WHEN LENGTH(TRIM(CAST(FSEQ AS VARCHAR(2)))) = 2
     C+ THEN SUBSTR(FSEQ,1,2) END) AS FACILITYCODE,
     C+ LNRF AS LOANREFERENCE
     C+ FROM CLOANCL
     C+ LEFT JOIN LEFEED ON LNRF = FELOAN
     C+ LEFT JOIN LEFCLYPP ON
     C+ XCNUM = FCUS AND XFACT = FTYP AND XFCNO = FSEQ AND XBKRPT = 'Y'
     C+ WHERE XBKRPT = 'Y'
     C+ UNION
     C+ SELECT DISTINCT FECNUM AS CUSTOMER,
     C+ CASE WHEN LENGTH(TRIM(CAST(FEFACL AS VARCHAR(5)))) = 1
     C+ THEN CONCAT('0000',FEFACL)
     C+ WHEN LENGTH(TRIM(CAST(FEFACL AS VARCHAR(5)))) = 2
     C+ THEN CONCAT('000',FEFACL)
     C+ WHEN LENGTH(TRIM(CAST(FEFACL AS VARCHAR(5)))) = 3
     C+ THEN CONCAT('00',FEFACL)
     C+ WHEN LENGTH(TRIM(CAST(FEFACL AS VARCHAR(5)))) = 4
     C+ THEN CONCAT('0',FEFACL)
     C+ WHEN LENGTH(TRIM(CAST(FEFACL AS VARCHAR(5)))) = 5
     C+ THEN SUBSTR(FEFACL,1,5) END AS FACILITYCODE,
     C+ FELOAN AS LOANREFERENCE
     C+ FROM LEFEED LEFT JOIN LEFCLYPP ON
     C+ XCNUM = FECNUM AND FEFACL = CONCAT(CASE
     C+ WHEN LENGTH(TRIM(CAST(XFACT AS VARCHAR(3)))) = 1
     C+ THEN CONCAT('00',XFACT)
     C+ WHEN LENGTH(TRIM(CAST(XFACT AS VARCHAR(3)))) = 2
     C+ THEN CONCAT('0',XFACT)
     C+ WHEN LENGTH(TRIM(CAST(XFACT AS VARCHAR(3)))) = 3
     C+ THEN SUBSTR(XFACT,1,3) END,
     C+ CASE WHEN LENGTH(TRIM(CAST(XFCNO AS VARCHAR(2)))) = 1
     C+ THEN CONCAT('0',XFCNO)
     C+ WHEN LENGTH(TRIM(CAST(XFCNO AS VARCHAR(2)))) = 2
     C+ THEN SUBSTR(XFCNO,1,2) END)
     C+ AND XBKRPT = 'Y' WHERE XBKRPT = 'Y'
     C+ ORDER BY CUSTOMER, FACILITYCODE, LOANREFERENCE

     C/END-EXEC
      *
      ** Terminate Program

     C                   EVAL      *INLR = *ON

     C                   RETURN
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILEB
     C/EJECT
**  CPY@
(c) Finastra International Limited 2018
